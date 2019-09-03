class Api::V1::RecaptchasController < ApplicationController
  include Api::V1::Concerns::GenericApiConcern
  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::NumberHelper
  skip_before_action :authenticate_user!
  require 'date'

  def verify
    body = {
        secret: Rails.application.config.RECAPTCHA_SECRET_KEY,
        response: params["token"]
    }.to_json

    response = call_generic_api('https://www.google.com', '/recaptcha/api/siteverify', {}, body, {}, 'POST')
  end
end
