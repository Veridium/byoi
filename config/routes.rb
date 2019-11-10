Rails.application.routes.draw do
  resources :purchases
  resources :discounts
  resources :plans
  resources :products
  devise_for :users, :controllers => {:registrations => "registrations", confirmations: 'confirmations'}
  namespace :api do
    get 'events' => "events#index"
    post 'pay' => "events#pay"
    post 'paid' => "events#paid"
    post 'locations' => "events#locations"
    post 'order' => "events#order"
    post 'payment' => "events#payment"
  end
  root 'billing#index', as: :billing
  #post '/card' => "billing#create_card", as: :create_payment_method
  #get '/card/new' => 'billing#new_card', as: :add_payment_method
  #get '/success' => 'billing#success', as: :success
  get "/:page" => "static#show"
end
