# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Articles', type: :request do
  describe 'get /index' do
    subject(:request) { get '/api/articles', params: params }

    let(:user) { create(:user, username: 'jake', bio: 'I work at statefarm', image: 'https://i.stack.imgur.com/xHWG8.jpg') }
    let(:user2) { create(:user, username: 'luke', bio: 'I work at codeminer42', image: 'https://i.stack.imgur.com/xHWG8.jpg') }

    let(:article1) do
      create(:article,
             title: 'How to train your dragon',
             description: 'Ever wonder how?',
             body: 'It takes a Jacobian',
             tag_list: %w[dragons training],
             user: user,
             created_at: 2.days.ago)
    end

    let(:article2) do
      create(:article,
             title: 'How to build good software',
             description: 'Ever heard of Spec initiative?',
             body: 'Write tests',
             tag_list: %w[coding tests],
             user: user2)
    end

    let(:params) do
      {}
    end

    let(:json_response) do
      {
        'articles' => [
          {
            'slug' => 'how-to-build-good-software',
            'title' => 'How to build good software',
            'description' => 'Ever heard of Spec initiative?',
            'body' => 'Write tests',
            'tagList' => %w[coding tests],
            'favorited' => false,
            'favoritesCount' => 0,
            'createdAt' => String,
            'updatedAt' => String,
            'author' => {
              'username' => 'luke',
              'bio' => 'I work at codeminer42',
              'image' => 'https://i.stack.imgur.com/xHWG8.jpg',
              'following' => false
            }
          },
          {
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
              'image' => 'https://i.stack.imgur.com/xHWG8.jpg',
              'following' => false
            }
          }
        ],
        'paginationInfo' => {
          'page' => 1,
          'perPage' => 10,
          'total' => 2,
          'totalPages' => 1
        }
      }
    end

    before do
      article1
      article2
    end

    it 'returns ok status' do
      request

      expect(response).to have_http_status(:ok)
    end

    it 'returns articles ordered by most recent first' do
      request

      expect(JSON.parse(response.body)).to match(json_response)
    end

    context 'when using tag parameter' do
      let(:params) do
        {
          tag: 'coding'
        }
      end

      let(:json_response) do
        {
          'articles' => [
            {
              'slug' => 'how-to-build-good-software',
              'title' => 'How to build good software',
              'description' => 'Ever heard of Spec initiative?',
              'body' => 'Write tests',
              'tagList' => %w[coding tests],
              'favorited' => false,
              'favoritesCount' => 0,
              'createdAt' => String,
              'updatedAt' => String,
              'author' => {
                'username' => 'luke',
                'bio' => 'I work at codeminer42',
                'image' => 'https://i.stack.imgur.com/xHWG8.jpg',
                'following' => false
              }
            }
          ],
          'paginationInfo' => {
            'page' => 1,
            'perPage' => 10,
            'total' => 1,
            'totalPages' => 1
          }
        }
      end

      it 'returns articles that has the provided tag' do
        request

        expect(JSON.parse(response.body)).to match(json_response)
      end
    end

    context 'when using author parameter' do
      let(:params) do
        {
          author: 'jake'
        }
      end

      let(:json_response) do
        {
          'articles' => [
            {
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
                'image' => 'https://i.stack.imgur.com/xHWG8.jpg',
                'following' => false
              }
            }
          ],
          'paginationInfo' => {
            'page' => 1,
            'perPage' => 10,
            'total' => 1,
            'totalPages' => 1
          }
        }
      end

      it 'returns articles that belongs to the username provided' do
        request

        expect(JSON.parse(response.body)).to match(json_response)
      end
    end
  end

  describe 'get /feed' do
    subject(:request) { get '/api/articles/feed', params: {}, headers: headers }

    let(:user) { create(:user, username: 'jake', bio: 'I work at statefarm', image: 'https://i.stack.imgur.com/xHWG8.jpg') }
    let(:user2) { create(:user, username: 'luke', bio: 'I work at codeminer42', image: 'https://i.stack.imgur.com/xHWG8.jpg') }
    let(:article1) do
      create(:article,
             title: 'How to train your dragon',
             description: 'Ever wonder how?',
             body: 'It takes a Jacobian',
             tag_list: %w[dragons training],
             user: user2,
             created_at: 2.days.ago)
    end
    let(:article2) do
      create(:article,
             title: 'How to build good software',
             description: 'Ever heard of Spec initiative?',
             body: 'Write tests',
             tag_list: %w[coding tests],
             user: user2)
    end

    let(:json_response) do
      {
        'articles' => [
          {
            'slug' => 'how-to-build-good-software',
            'title' => 'How to build good software',
            'description' => 'Ever heard of Spec initiative?',
            'body' => 'Write tests',
            'tagList' => %w[coding tests],
            'favorited' => false,
            'favoritesCount' => 0,
            'createdAt' => String,
            'updatedAt' => String,
            'author' => {
              'username' => 'luke',
              'bio' => 'I work at codeminer42',
              'image' => 'https://i.stack.imgur.com/xHWG8.jpg',
              'following' => true
            }
          },
          {
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
              'username' => 'luke',
              'bio' => 'I work at codeminer42',
              'image' => 'https://i.stack.imgur.com/xHWG8.jpg',
              'following' => true
            }
          }
        ],
        'paginationInfo' => {
          'page' => 1,
          'perPage' => 10,
          'total' => 2,
          'totalPages' => 1
        }
      }
    end
    let(:token) { user.generate_jwt }
    let(:headers) { { 'Authorization' => "Bearer #{token}" } }

    before do
      article1
      article2
      create(:article)

      user.follow user2
    end

    it 'returns ok status' do
      request

      expect(response).to have_http_status(:ok)
    end

    it 'returns articles ordered by most recent first' do
      request

      expect(JSON.parse(response.body)).to match(json_response)
    end
  end

  describe 'post /create' do
    subject(:request) { post '/api/articles', params: params, headers: headers }

    let(:params) { {} }

    context 'when user is not authenticated' do
      let(:headers) { {} }

      it 'returns unauthorized status' do
        request

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is authenticated' do
      let(:user) { create(:user, username: 'jake', bio: 'I work at statefarm', image: 'https://i.stack.imgur.com/xHWG8.jpg') }
      let(:token) { user.generate_jwt }
      let(:headers) { { Authorization: "Bearer #{token}" } }

      context 'with data is invalid' do
        let(:params) do
          {
            article: {
              title: 'How to train your dragon'
            }
          }
        end

        let(:json_response) do
          {
            'errors' => {
              'body' => [
                "can't be blank"
              ],
              'description' => [
                "can't be blank"
              ]
            }
          }
        end

        it 'returns unprocessable entity status' do
          request

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns error messages' do
          request

          expect(JSON.parse(response.body)).to match(json_response)
        end
      end

      context 'with data is valid' do
        let(:params) do
          {
            article: {
              title: 'How to train your dragon',
              description: 'Ever wonder how?',
              body: 'It takes a Jacobian',
              tag_list: %w[dragons training]
            }
          }
        end

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
                'image' => 'https://i.stack.imgur.com/xHWG8.jpg',
                'following' => false
              }
            }
          }
        end

        it 'returns created status' do
          request

          expect(response).to have_http_status(:created)
        end

        it 'returns article attributes' do
          request

          expect(JSON.parse(response.body)).to match(json_response)
        end
      end
    end
  end

  describe 'get /show' do
    subject(:request) { get "/api/articles/#{article_slug}" }

    let(:user) { create(:user, username: 'jake', bio: 'I work at statefarm', image: 'https://i.stack.imgur.com/xHWG8.jpg') }

    let(:article) do
      create(:article,
             title: 'How to train your dragon',
             description: 'Ever wonder how?',
             body: 'It takes a Jacobian',
             tag_list: %w[dragons training],
             user: user)
    end

    context 'when article is found' do
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
              'image' => 'https://i.stack.imgur.com/xHWG8.jpg',
              'following' => false
            }
          }
        }
      end

      it 'returns ok status' do
        request

        expect(response).to have_http_status(:ok)
      end

      it 'returns article attributes' do
        request

        expect(JSON.parse(response.body)).to match(json_response)
      end
    end

    context 'when article is not found' do
      let(:article_slug) { 'non-existing-slug' }
      let(:json_response) do
        {
          'errors' => {
            'message' => 'Article not found'
          }
        }
      end

      it 'returns not_found status' do
        request

        expect(response).to have_http_status(:not_found)
      end

      it 'returns article attributes' do
        request

        expect(JSON.parse(response.body)).to match(json_response)
      end
    end
  end

  describe 'put /update' do
    subject(:request) { put "/api/articles/#{article_slug}", params: params, headers: headers }

    let(:user) { create(:user, username: 'jake', bio: 'I work at statefarm', image: 'https://i.stack.imgur.com/xHWG8.jpg') }

    let(:article) do
      create(:article,
             title: 'How to train your dragon',
             description: 'Ever wonder how?',
             body: 'It takes a Jacobian',
             tag_list: %w[dragons training],
             user: user)
    end

    let(:article_slug) { article.slug }

    let(:params) { {} }

    context 'when user is not authenticated' do
      let(:headers) { {} }

      it 'returns unauthorized status' do
        request

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is authenticated' do
      let(:token) { user.generate_jwt }
      let(:headers) { { Authorization: "Bearer #{token}" } }

      context 'with the current_user not being the author of the article' do
        let(:author) { create(:user) }
        let(:token) { author.generate_jwt }

        it 'returns forbidden status' do
          request

          expect(response).to have_http_status(:forbidden)
        end
      end

      context 'with data is invalid' do
        let(:params) do
          {
            article: {
              title: ''
            }
          }
        end

        let(:json_response) do
          {
            'errors' => {
              'title' => [
                "can't be blank"
              ]
            }
          }
        end

        it 'returns unprocessable entity status' do
          request

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns error messages' do
          request

          expect(JSON.parse(response.body)).to match(json_response)
        end
      end

      context 'with data is valid' do
        let(:params) do
          {
            article: {
              title: 'How to improve your dragon',
              tag_list: %w[dragons training improve]
            }
          }
        end

        let(:json_response) do
          {
            'article' => {
              'slug' => 'how-to-improve-your-dragon',
              'title' => 'How to improve your dragon',
              'description' => 'Ever wonder how?',
              'body' => 'It takes a Jacobian',
              'tagList' => %w[dragons training improve],
              'favorited' => false,
              'favoritesCount' => 0,
              'createdAt' => String,
              'updatedAt' => String,
              'author' => {
                'username' => 'jake',
                'bio' => 'I work at statefarm',
                'image' => 'https://i.stack.imgur.com/xHWG8.jpg',
                'following' => false
              }
            }
          }
        end

        it 'returns ok status' do
          request

          expect(response).to have_http_status(:ok)
        end

        it 'returns article attributes' do
          request

          expect(JSON.parse(response.body)).to match(json_response)
        end
      end

      context 'when article is not found' do
        let(:article_slug) { 'non-existing-slug' }
        let(:json_response) do
          {
            'errors' => {
              'message' => 'Article not found'
            }
          }
        end

        it 'returns not_found status' do
          request

          expect(response).to have_http_status(:not_found)
        end

        it 'returns article attributes' do
          request

          expect(JSON.parse(response.body)).to match(json_response)
        end
      end
    end
  end

  describe 'delete /destroy' do
    subject(:request) { delete "/api/articles/#{article_slug}", headers: headers }

    let(:user) { create(:user, username: 'jake', bio: 'I work at statefarm', image: 'https://i.stack.imgur.com/xHWG8.jpg') }

    let(:article) { create(:article, user: user) }

    let(:article_slug) { article.slug }

    context 'when user is not authenticated' do
      let(:headers) { {} }

      it 'returns unauthorized status' do
        request

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is authenticated' do
      let(:token) { user.generate_jwt }
      let(:headers) { { Authorization: "Bearer #{token}" } }

      context 'with the current_user not being the author of the article' do
        let(:author) { create(:user) }
        let(:token) { author.generate_jwt }

        it 'returns forbidden status' do
          request

          expect(response).to have_http_status(:forbidden)
        end
      end

      context 'with article is not found' do
        let(:article_slug) { 'non-existing-slug' }

        let(:json_response) do
          {
            'errors' => {
              'message' => 'Article not found'
            }
          }
        end

        it 'returns not_found status' do
          request

          expect(response).to have_http_status(:not_found)
        end

        it 'returns article attributes' do
          request

          expect(JSON.parse(response.body)).to match(json_response)
        end
      end

      context 'with article is found' do
        it 'returns ok status' do
          request

          expect(response).to have_http_status(:no_content)
        end

        it 'destroys article attributes' do
          request

          expect { Article.find_by!(slug: article_slug) }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
