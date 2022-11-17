require 'rails_helper'

RSpec.describe "Comments", type: :request do
  describe 'get /index' do
    subject(:request) { get "/api/articles/#{article_slug}/comments", params: params }

    let(:user) { create(:user, username: 'jake', bio: 'I work at statefarm', image: 'https://i.stack.imgur.com/xHWG8.jpg') }
    let(:user2) { create(:user, username: 'luke', bio: 'I work at codeminer42', image: 'https://i.stack.imgur.com/xHWG8.jpg') }

    let!(:article) do
      create(:article,
             title: 'How to train your dragon',
             description: 'Ever wonder how?',
             body: 'It takes a Jacobian',
             tag_list: %w[dragons training],
             user: user)
    end

    let(:article_slug) { article.slug }

    let(:comment1) do
      create(:comment,
             body: 'It takes a Jacobian',
             user: user,
             article: article,
             created_at: 2.days.ago)
    end

    let(:comment2) do
      create(:comment,
             body: 'Write tests',
             article: article,
             user: user2)
    end

    let(:params) do
      {}
    end

    let(:json_response) do
      {
        'comments' => [
          {
            'id' => comment2.id,
            'body' => 'Write tests',
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
            'id' => comment1.id,
            'body' => 'It takes a Jacobian',
            'createdAt' => String,
            'updatedAt' => String,
            'author' => {
              'username' => 'jake',
              'bio' => 'I work at statefarm',
              'image' => 'https://i.stack.imgur.com/xHWG8.jpg',
              'following' => false
            }
          }
        ]
      }
    end

    before do
      comment1
      comment2
    end

    it 'returns ok status' do
      request

      expect(response).to have_http_status(:ok)
    end

    it 'returns comments ordered by most recent first' do
      request

      expect(JSON.parse(response.body)).to match(json_response)
    end
  end

  describe 'post /create' do
    subject(:request) { post "/api/articles/#{article_slug}/comments", params: params, headers: headers }

    let(:user) { create(:user, username: 'jake', bio: 'I work at statefarm', image: 'https://i.stack.imgur.com/xHWG8.jpg') }

    let!(:article) do
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

      context 'with data is invalid' do
        let(:params) do
          {
            comment: {
              body: ''
            }
          }
        end

        let(:json_response) do
          {
            'errors' => {
              'body' => [
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
            comment: {
              body: 'It takes a Jacobian'
            }
          }
        end

        let(:json_response) do
          {
            'comment' => {
              'id' => Integer,
              'body' => 'It takes a Jacobian',
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

        it 'returns comment attributes' do
          request

          expect(JSON.parse(response.body)).to match(json_response)
        end
      end
    end
  end

  describe 'delete /destroy' do
    subject(:request) { delete "/api/articles/#{comment.article.slug}/comments/#{comment_id}", headers: headers }

    let(:user) { create(:user, username: 'jake', bio: 'I work at statefarm', image: 'https://i.stack.imgur.com/xHWG8.jpg') }

    let!(:comment) { create(:comment, user: user) }

    let(:comment_id) { comment.id }

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

      context 'with the current_user not being the author of the comment' do
        let(:author) { create(:user) }
        let(:token) { author.generate_jwt }

        it 'returns forbidden status' do
          request

          expect(response).to have_http_status(:forbidden)
        end
      end

      context 'with comment_id is not found' do
        let(:comment_id) { 'non-existing-slug' }

        let(:json_response) do
          {
            'errors' => {
              'message' => 'Comment not found'
            }
          }
        end

        it 'returns not_found status' do
          request

          expect(response).to have_http_status(:not_found)
        end

        it 'returns comment attributes' do
          request

          expect(JSON.parse(response.body)).to match(json_response)
        end
      end

      context 'with comment found' do
        it 'returns ok status' do
          request

          expect(response).to have_http_status(:no_content)
        end

        it 'destroys comment attributes' do
          request

          expect { Comment.find(comment_id) }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
