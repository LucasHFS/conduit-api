# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Follows', type: :request do
  let(:token) { current_user.generate_jwt }
  let(:headers) { { Authorization: "Bearer #{token}" } }

  let(:current_user) { create(:user) }

  let(:celeb_user) { create(:user) }

  let(:username) { celeb_user.username }

  describe 'post /:create' do
    subject(:request) { post "/api/profiles/#{username}/follow", headers: headers }

    let(:json_response) do
      {
        'profile' => {
          'username' => celeb_user.username,
          'bio' => celeb_user.bio,
          'image' => 'https://i.stack.imgur.com/xHWG8.jpg',
          'following' => true
        }
      }
    end

    it 'returns created status' do
      request

      expect(response).to have_http_status(:created)
    end

    it 'returns celeb user profile with followed containing true' do
      request

      expect(JSON.parse(response.body)).to match(json_response)
    end

    context 'when current user already followed the celeb_user' do
      before { current_user.follow(celeb_user) }

      let(:json_response) do
        {
          'profile' => {
            'username' => celeb_user.username,
            'bio' => celeb_user.bio,
            'image' => 'https://i.stack.imgur.com/xHWG8.jpg',
            'following' => true
          }
        }
      end

      it 'returns created status' do
        request

        expect(response).to have_http_status(:created)
      end

      it 'returns celeb user profile with followed containing true' do
        request

        expect(JSON.parse(response.body)).to match(json_response)
      end
    end
  end

  describe 'delete /:destroy' do
    subject(:request) { delete "/api/profiles/#{username}/follow", headers: headers }

    let(:json_response) do
      {
        'profile' => {
          'username' => celeb_user.username,
          'bio' => celeb_user.bio,
          'image' => 'https://i.stack.imgur.com/xHWG8.jpg',
          'following' => false
        }
      }
    end

    before { current_user.follow(celeb_user) }

    it 'returns ok status' do
      request

      expect(response).to have_http_status(:ok)
    end

    it 'returns celeb user profile with followed containing false' do
      request

      expect(JSON.parse(response.body)).to match(json_response)
    end

    context "when current user didn't followed the celeb_user" do
      let(:json_response) do
        {
          'profile' => {
            'username' => celeb_user.username,
            'bio' => celeb_user.bio,
            'image' => 'https://i.stack.imgur.com/xHWG8.jpg',
            'following' => false
          }
        }
      end

      it 'returns ok status' do
        request

        expect(response).to have_http_status(:ok)
      end

      it 'returns celeb user profile with followed containing true' do
        request

        expect(JSON.parse(response.body)).to match(json_response)
      end
    end
  end
end
