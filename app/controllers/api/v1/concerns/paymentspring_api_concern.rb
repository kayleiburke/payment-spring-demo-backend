module Api::V1::Concerns::PaymentspringApiConcern
  extend ActiveSupport::Concern
  include Api::V1::Concerns::GenericApiConcern

  # generic implementation of simple linstener in active record
  def call_api(url, body, params, request_type)

    basic_auth = {
        username: Rails.application.config.PAYMENTSPRING_PRIVATE_API_KEY,
        password: ""
    }

    response = call_generic_api('https://api.paymentspring.com', url, basic_auth, body, params, request_type)

    if response["errors"]
      response["errors"] = response["errors"].collect { |e| e["message"] }
    end

    response
  end
end
