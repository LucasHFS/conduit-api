Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  scope :api, constraints: AcceptJsonConstraint.new do
    namespace :v1 do
      resources :health, only: :index
    end
  end
end
