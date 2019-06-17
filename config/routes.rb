Rails.application.routes.draw do

  devise_for :users, controllers: {
      sessions: 'users/sessions'
  }

  namespace :api  do
    namespace :v1 do
      resources :payments, only: :create
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
