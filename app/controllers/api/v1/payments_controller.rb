class Api::V1::PaymentsController < ApplicationController
  before_action :authenticate_user!

  def create
    conn = Faraday.new('https://api.paymentspring.com') do |c|
      c.use Faraday::Adapter::NetHttp
    end

    response = conn.post do |request|
      request.url '/api/v1/charge'
      request.headers["Authorization"] = 'Basic ' + Base64.encode64(Rails.application.config.PAYMENTSPRING_PRIVATE_API_KEY)
      request.headers['Content-Type'] = 'application/json'
      request.body = {
          token: params[:token],
          amount: params[:amount],
          send_receipt: params[:send_receipt]
      }.to_json
    end

    parsed_response = JSON.parse(response.body)
    render json: parsed_response
  end
end