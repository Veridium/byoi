Rails.application.routes.draw do
  resources :purchases
  resources :discounts
  resources :plans
  resources :products
  devise_for :users, :controllers => {:registrations => "registrations", confirmations: 'confirmations'}
  namespace :api do
    post 'plans' => "events#plans"
    post 'payment' => "events#payment"
  end
  root 'billing#index', as: :billing
  get "/:page" => "static#show"
end
