# frozen_string_literal: true

class FollowsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user!

  def create
    current_user.follow(@user) if current_user != @user

    render 'profiles/show', status: :created
  end

  def destroy
    current_user.stop_following(@user) if current_user != @user

    render 'profiles/show'
  end

  private

  def find_user!
    @user = User.find_by!(username: params[:profile_username])
  end
end
