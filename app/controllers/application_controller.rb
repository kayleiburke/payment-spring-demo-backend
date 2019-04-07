class ApplicationController < ActionController::API
  before_action :authenticate_user!

  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include ActionController::HttpAuthentication::Token::ControllerMethods

  acts_as_token_authentication_handler_for User

  alias_method :devise_current_user, :current_user

  def current_user
    authenticate_with_http_token do |token, options|
      User.find_by(authentication_token: token)
    end
  end
end
