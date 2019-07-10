class Api::V1::PaymentsController < ApplicationController
  before_action :authenticate_user!
  include Api::V1::Concerns::PaymentspringApiConcern

  def index
    parsed_response = call_api('api/v1/transactions', {}, params, "GET")
    render json: parsed_response
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