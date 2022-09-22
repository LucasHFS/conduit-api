Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  scope :api, defaults: { format: :json } do
    resources :health, only: :index

    devise_for :users, controllers: { sessions: :sessions, registrations: :registrations },
    path_names: { sign_in: :login }

    resource :user, only: [:show, :update]
  end
end
