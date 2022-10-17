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

  acts_as_followable
  acts_as_follower

  def generate_jwt
    JWT.encode({
                 id: id,
                 exp: 60.days.from_now.to_i
               },
               Rails.application.credentials.secret_key_base)
  end

  def favorite(article)
    favorites.find_or_create_by(article: article)
  end

  def unfavorite(article)
    favorites.where(article: article).destroy_all

    article.reload
  end

  def favorited?(article)
    favorites.find_by(article: article).present?
  end
end
