# frozen_string_literal: true

Rails.application.routes.draw do
  resources :products
  resources :checkouts, only: [:create]
  resources :webhooks,  only: [:create]

  root 'products#index'
end
