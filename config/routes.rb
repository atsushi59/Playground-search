# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root 'static_pages#index'
  post 'search', to: 'searches#search'
  get 'index', to: 'searches#index'
  get '/terms_of_service', to: 'static_pages#terms_of_service'
  get '/privacy_policy', to: 'static_pages#privacy_policy'
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development? 
end
