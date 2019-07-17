module Api::V1::Concerns::PaymentspringApiConcern
  extend ActiveSupport::Concern
  include Api::V1::Concerns::GenericApiConcern

  # generic implementation of simple linstener in active record
  def call_api(url, body, params, request_type)

    headers = {
        'Authorization': 'Basic ' + Base64.encode64(Rails.application.config.PAYMENTSPRING_PRIVATE_API_KEY),
        'Content-Type': 'application/json'
    }

    response = call_generic_api('https://api.paymentspring.com', url, headers, body, params, request_type)

    if response["errors"]
      response["errors"] = response["errors"].collect { |e| e["message"] }
    end

    response
  end
end