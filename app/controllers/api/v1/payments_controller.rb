class Api::V1::PaymentsController < ApplicationController
  before_action :authenticate_user!
  include Api::V1::Concerns::PaymentspringApiConcern
  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::NumberHelper
  require 'date'

  def index
    payments = Payment.all.order(created_at: :desc).page(params[:page]).per_page(params[:per_page].to_i)
    total_pages =  (Payment.all.count/params[:per_page].to_f).ceil

    render json: { total_pages: total_pages, payments: JSON.parse(payments.to_json({:include => :user})) }.to_json
  end

  def chart_data
    response = call_api('api/v1/transactions', {}, { limit: 100, offset: 0 }, "GET")

    total_results = 0
    total_donations = 0

    if response["list"]
      total_results = response["meta"]["total_results"]
      response = response["list"].sort_by { |h| h["created_at"] }.group_by { |h| Date.parse((Time.parse h["created_at"]).getlocal.to_s) }.map do |k,v|
        amount = (v.map {|h1| h1["amount_settled"]}.sum)/100.0
        total_donations += amount

        v.each do |transaction|
          create_payment(transaction)
        end

        [k.strftime("%m/%d"), { v: amount, f: number_to_currency(amount)}]
      end

      start_date = Date.parse(response[0][0])
      end_date = Date.parse(response[response.size - 1][0])

      response = {
          list: response,
          count: total_results,
          total: total_donations.round(2),
          timespan: distance_of_time_in_words(start_date, end_date)
      }.to_json

      render json: response
    else
      if response["errors"]
        Rails.logger.info "Errors from PaymentSpring: " + response["errors"]
        render json: {
            errors: response["errors"]
        }, status: :unprocessable_entity
      end
    end
  end

  def create
    payment_params = {
        token: params[:token],
        amount: params[:amount],
        send_receipt: params[:send_receipt],
        customer_id: current_user.id
    }

    parsed_response = call_api('api/v1/charge', {}.to_json, payment_params, "POST")

    if parsed_response["errors"]
      handle_error(parsed_response["errors"])
    else
      Payment.create(user: current_user, amount: params[:amount]/100.0, description: params[:description], payment_id: parsed_response["id"], created_at: parsed_response["created_at"])
      render json: parsed_response
    end
  end

  private

  def handle_error(error_message)
    render json: {
        errors: error_message
    }, status: :unprocessable_entity
  end

  # create a payment in our local database if there exists a past payment in PaymentSpring that
  # has not been accounted for in our local db
  def create_payment(data)
    payment_id = data["id"]
    amount = data["amount_settled"]

    default_user = User.find_by(email: "kaylei.burke@gmail.com")
    payment = Payment.find_by(payment_id: payment_id)

    if !payment
      payment = Payment.find_by(amount: amount, payment_id: nil)

      if payment
        payment.payment_id = payment_id
        payment.save
      else
        Payment.create(amount: amount, payment_id: payment_id, user: default_user, created_at: data["created_at"])
      end
    end
  end
end
