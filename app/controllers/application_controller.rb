# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::ParameterMissing, with: :parameter_missing

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  respond_to :json

  before_action :authenticate_user

  def record_not_found(exception)
    response = { errors: { message: "#{exception.model} not found" } }
    render json: response, status: :not_found
  end

  def parameter_missing(exception)
    response = { errors: { exception.param.to_s => [exception.message.split(':')[0]] }.compact }
    render json: response, status: :unprocessable_entity
  end

  private

  def authenticate_user!(_options = {})
    head :unauthorized unless signed_in?
  end

  def current_user
    @current_user ||= super || User.find(@current_user_id)
  end

  def signed_in?
    @current_user_id.present?
  end

  def authenticate_user
    return if request.headers['Authorization'].blank?

    authenticate_or_request_with_http_token do |token|
      jwt_payload = JWT.decode(token, Rails.application.credentials.secret_key_base).first

      @current_user_id = jwt_payload['id']
    rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
      head :unauthorized
    end
  end
end
