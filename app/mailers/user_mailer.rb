class UserMailer < Devise::Mailer
  # helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'user_mailer' # to make sure that your mailer uses the devise views

  def devise_mail(record, action, opts={})
    initialize_from_record(record)
    make_bootstrap_mail(headers_for(action, opts)) do |format|
      format.text
      format.html
    end
  end
end