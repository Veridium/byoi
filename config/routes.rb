Rails.application.routes.draw do
  devise_for :users
  root 'billing#index', as: :billing
  post '/card' => "billing#create_card", as: :create_payment_method
  get '/card/new' => 'billing#new_card', as: :add_payment_method
  get '/success' => 'billing#success', as: :success
end
