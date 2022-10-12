# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Favorites', type: :request do
  let(:token) { user.generate_jwt }
  let(:headers) { { Authorization: "Bearer #{token}" } }

  let(:user) { create(:user, username: 'jake', bio: 'I work at statefarm', image: 'https://i.stack.imgur.com/xHWG8.jpg') }

  let!(:article) do
    create(:article,
           title: 'How to train your dragon',
           description: 'Ever wonder how?',
           body: 'It takes a Jacobian',
           tag_list: %w[dragons training],
           user: user)
  end

  describe 'post /:create' do
    subject(:request) { post "/api/articles/#{article_slug}/favorite", headers: headers }

    let(:article_slug) { article.slug }

    let(:json_response) do
      {
        'article' => {
          'slug' => 'how-to-train-your-dragon',
          'title' => 'How to train your dragon',
          'description' => 'Ever wonder how?',
          'body' => 'It takes a Jacobian',
          'tagList' => %w[dragons training],
          'favorited' => true,
          'favoritesCount' => 1,
          'createdAt' => String,
          'updatedAt' => String,
          'author' => {
            'username' => 'jake',
            'bio' => 'I work at statefarm',
            'image' => 'https://i.stack.imgur.com/xHWG8.jpg'
          }
        }
      }
    end

    it 'returns http success' do
      request

      expect(response).to have_http_status(:created)
    end

    it 'returns article attributes' do
      request

      expect(JSON.parse(response.body)).to match(json_response)
    end
  end

  describe 'delete /:destroy' do
    subject(:request) { delete "/api/articles/#{article_slug}/favorite", headers: headers }

    let(:article_slug) { article.slug }

    let(:json_response) do
      {
        'article' => {
          'slug' => 'how-to-train-your-dragon',
          'title' => 'How to train your dragon',
          'description' => 'Ever wonder how?',
          'body' => 'It takes a Jacobian',
          'tagList' => %w[dragons training],
          'favorited' => false,
          'favoritesCount' => 0,
          'createdAt' => String,
          'updatedAt' => String,
          'author' => {
            'username' => 'jake',
            'bio' => 'I work at statefarm',
            'image' => 'https://i.stack.imgur.com/xHWG8.jpg'
          }
        }
      }
    end

    it 'returns http success' do
      request

      expect(response).to have_http_status(:success)
    end

    it 'returns article attributes' do
      request

      expect(JSON.parse(response.body)).to match(json_response)
    end
  end
end
