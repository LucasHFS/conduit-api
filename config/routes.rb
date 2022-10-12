# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  scope :api, defaults: { format: :json } do
    resources :health, only: :index

    devise_for :users, controllers: { sessions: :sessions, registrations: :registrations },
                       path_names: { sign_in: :login }

    resource :user, only: %i[show update]

    resources :articles, param: :slug, except: %i[edit new] do
      resource :favorite, only: %i[create destroy]
    end
  end
end
