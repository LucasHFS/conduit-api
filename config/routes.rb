# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  scope :api, defaults: { format: :json } do
    resources :health, only: :index

    devise_for :users, controllers: { sessions: :sessions, registrations: :registrations },
                       path_names: { sign_in: :login }

    resource :user, only: %i[show update]

    resources :profiles, param: :username, only: [:show] do
      resource :follow, only: %i[create destroy]
    end

    resources :articles, param: :slug, except: %i[edit new] do
      get :feed, on: :collection

      resource :favorite, only: %i[create destroy]

      resources :comments, only: %i[index create destroy]
    end

    resources :tags, only: %i[index]
  end
end
