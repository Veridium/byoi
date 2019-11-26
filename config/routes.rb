Rails.application.routes.draw do
  resources :members
  resources :purchases
  resources :discounts
  resources :plans
  resources :products
  devise_for :users, :controllers => {
    :registrations => "registrations",
    :confirmations => 'confirmations',
    :passwords => 'passwords' }
  namespace :api do
    post 'plan' => "events#plan"
    post 'plans' => "events#plans"
    post 'payment' => "events#payment"
    post 'confirm' => "events#confirm"
    post 'resend' => "events#resend"
    post 'reset' => "events#reset"
    post 'delete' => "events#delete"
  end
  root 'billing#index', as: :billing
  get "/:page" => "static#show"
end
