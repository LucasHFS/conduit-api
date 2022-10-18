# frozen_string_literal: true

json.call(article, :title, :slug, :body, :description, :tag_list, :created_at, :updated_at)
json.favorited signed_in? ? current_user.favorited?(article) : false
json.favorites_count article.favorites_count || 0

json.author article.user, partial: 'profiles/profile', as: :user
