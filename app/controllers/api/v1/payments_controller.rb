class Api::V1::PaymentsController < ApplicationController
  before_action :authenticate_user!
  include Api::V1::Concerns::PaymentspringApiConcern
  include ActionView::Helpers::DateHelper
  require 'date'

  def index
    response = call_api('api/v1/transactions', {}, { limit: 100, offset: 0 }, "GET")

    total_results = 0
    total_donations = 0

    if response["list"]
      total_results = response["meta"]["total_results"]
      response = response["list"].sort_by { |h| h["created_at"] }.group_by { |h| Date.parse((Time.parse h["created_at"]).getlocal.to_s) }.map do |k,v|
        amount = (v.map {|h1| h1["amount_settled"]}.sum)/100.0
        total_donations += amount
        [k.strftime("%m/%d"), amount]
      end

      start_date = Date.parse(response[0][0])
      end_date = Date.parse(response[response.size - 1][0])

      response = {
          list: response,
          count: total_results,
          total: total_donations.round(2),
          timespan: distance_of_time_in_words(start_date, end_date)
      }.to_json
    end

    render json: response
  end

  def create
    body = {
        token: params[:token],
        amount: params[:amount],
        send_receipt: params[:send_receipt]
    }.to_json

    parsed_response = call_api('api/v1/charge', body, {}, "POST")

    render json: parsed_response
  end
end