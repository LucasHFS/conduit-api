# frozen_string_literal: true

class AddFavoritesCountToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :favorites_count, :integer
  end
end
