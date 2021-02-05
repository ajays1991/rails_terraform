require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq" # mount Sidekiq::Web in your Rails app

  get '/', :to => 'home#index'
  resources :notes, only: [:index, :create]
end
