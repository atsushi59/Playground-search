# frozen_string_literal: true

Rails.application.routes.draw do
  root 'static_pages#index'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  resource :profiles
  resources :places do
    resources :place_favorites, only: %i[create destroy]
    resources :place_histories, only: [:create]
    resources :reviews, only: [:show, :new, :create, :edit, :update, :destroy]do
      resource :reviews_like, only: [:create, :destroy]
    end
  end
  resources :place_favorites, only: [:index]
  resources :place_histories, only: [:index]
  resources :reviews, only: [:index]
  get 'index', to: 'searches#index'
  post 'search', to: 'searches#search'
  get '/terms_of_service', to: 'static_pages#terms_of_service'
  get '/privacy_policy', to: 'static_pages#privacy_policy'
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development? 
end
