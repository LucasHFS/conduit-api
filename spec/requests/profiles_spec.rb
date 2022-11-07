# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Profiles', type: :request do
  describe 'get /show' do
    subject(:request) { get "/api/profiles/#{username}" }

    context 'when profile is found' do
      let(:celeb_user) { create(:user, username: 'jake', bio: 'I work at statefarm', image: 'https://i.stack.imgur.com/xHWG8.jpg') }
      let(:username) { celeb_user.username }

      let(:json_response) do
        {
          'profile' => {
            'username' => 'jake',
            'bio' => 'I work at statefarm',
            'image' => 'https://i.stack.imgur.com/xHWG8.jpg',
            'following' => false
          }
        }
      end

      it 'returns ok status' do
        request

        expect(response).to have_http_status(:ok)
      end

      it 'returns profile attributes' do
        request

        expect(JSON.parse(response.body)).to match(json_response)
      end
    end

    context 'when profile is not found' do
      let(:username) { 'non-existing-username' }

      let(:json_response) do
        {
          'errors' => {
            'message' => 'User not found'
          }
        }
      end

      it 'returns not_found status' do
        request

        expect(response).to have_http_status(:not_found)
      end

      it 'returns an error message' do
        request

        expect(JSON.parse(response.body)).to match(json_response)
      end
    end
  end
end
