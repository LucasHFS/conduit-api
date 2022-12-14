# frozen_string_literal: true

json.articles do |json|
  json.array! @articles, partial: 'articles/article', as: :article
end

json.pagination_info @pagination_info
