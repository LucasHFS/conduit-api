# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, uniqueness: { case_sensitive: true },
                       presence: true,
                       allow_blank: false

  has_many :articles, dependent: :destroy
  has_many :favorites, dependent: :destroy

  def generate_jwt
    JWT.encode({
                 id: id,
                 exp: 60.days.from_now.to_i
               },
               Rails.application.credentials.secret_key_base)
  end
end
