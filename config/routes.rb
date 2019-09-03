Rails.application.routes.draw do

  devise_for :users, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      confirmations: 'users/confirmations'
  }

  namespace :api  do
    namespace :v1 do
      resources :payments
      resources :recaptchas do
        collection do
          post :verify
        end
      end
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
