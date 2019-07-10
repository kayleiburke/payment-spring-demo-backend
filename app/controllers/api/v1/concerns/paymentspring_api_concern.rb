module Api::V1::Concerns::PaymentspringApiConcern
  extend ActiveSupport::Concern

  # generic implementation of simple linstener in active record
  def call_api(url, body, params, request_type)

    conn = Faraday.new('https://api.paymentspring.com') do |c|
      c.use Faraday::Adapter::NetHttp
    end

    headers = {
        'Authorization': 'Basic ' + Base64.encode64(Rails.application.config.PAYMENTSPRING_PRIVATE_API_KEY),
        'Content-Type': 'application/json'
    }

    if "GET".casecmp(request_type) == 0
      response = conn.get do |request|
        request.url url
        request.headers = headers
        request.params = params
      end
    elsif "POST".casecmp(request_type) == 0
      response = conn.post do |request|
        request.url url
        request.headers = headers
        request.body = body
      end
    end

    parsed_response = JSON.parse(response.body)
    parsed_response
  end
end