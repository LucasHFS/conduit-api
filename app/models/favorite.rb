# frozen_string_literal: true

class Favorite < ApplicationRecord
  belongs_to :article, counter_cache: true
  belongs_to :user
end
