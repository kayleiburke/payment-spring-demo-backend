class Api::V1::PaymentsController < ApplicationController
  before_action :authenticate_user!
  include Api::V1::Concerns::PaymentspringApiConcern
  include ActionView::Helpers::NumberHelper
  require 'date'

  def index
    response = call_api('api/v1/transactions', {}, { limit: 100, offset: 0 }, "GET")

    if response["list"]
      response = response["list"].sort_by { |h| h["created_at"] }.group_by { |h| Date.parse h["created_at"] }.map do |k,v|
        amount = v.map {|h1| h1["amount_settled"]}.inject(:+)/100.0
        [k.strftime("%m/%d"), amount]
      end
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