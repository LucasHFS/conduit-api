# frozen_string_literal: true

class Article < ApplicationRecord
  include Filterable

  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy

  before_validation :set_slug

  validates :title, presence: true, allow_blank: false
  validates :body, presence: true, allow_blank: false
  validates :description, presence: true, allow_blank: false
  validates :slug, uniqueness: true

  scope :authored_by, ->(username) { where(user: User.where(username: username)) }
  scope :favorited_by, ->(username) { joins(:favorites).where(favorites: { user: User.where(username: username) }) }

  scope :filter_by_author, ->(author) { authored_by(author) }
  scope :filter_by_tag, ->(tag) { tagged_with(tag) }
  scope :filter_by_favorited, ->(favorited) { favorited_by(favorited) }

  acts_as_taggable_on :tags

  private

  def set_slug
    self.slug = title.tr('_', '-').parameterize
  end
end
