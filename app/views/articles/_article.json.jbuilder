# frozen_string_literal: true

json.call(article, :title, :slug, :body, :description, :tag_list, :created_at, :updated_at)

json.author article.user, partial: 'profiles/profile', as: :user
