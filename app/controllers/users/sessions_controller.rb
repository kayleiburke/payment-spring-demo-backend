# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  skip_before_action :verify_signed_out_user

  # POST /resource/sign_in
  def create
    authenticate_with_http_basic do |email, password|
      success, user = User.valid_login?(email, password)
      if success
        sign_in(User.find_by(email: email), scope: :user)

        paymentSpringData = {
            paymentspring_api_key: Rails.application.config.PAYMENTSPRING_API_KEY
        }

        render json: user.as_json(only: [:email, :authentication_token]).merge(paymentSpringData),
                    status: :created
      else
        head :unauthorized
      end
    end
  end

  # DELETE /resource/sign_out
  def destroy
    current_user.reset_authentication_token!
    head :ok
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  private

  # def current_user
  #   authenticate_with_http_token do |token, options|
  #     User.find_by(authentication_token: token)
  #   end
  # end
end
