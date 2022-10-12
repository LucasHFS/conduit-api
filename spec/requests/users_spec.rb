# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'PUT /update' do
    subject(:request) { put '/api/user', params: params, headers: headers }

    let!(:user) { create(:user, email: 'lucas@sample.com') }
    let(:params) do
      {}
    end

    context 'when user is not authenticated' do
      it 'returns unauthorized status' do
        request

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is authenticated' do
      let(:token) { user.generate_jwt }
      let(:headers) { { 'Authorization' => "Bearer #{token}" } }

      context 'when invalid attributes' do
        let(:params) do
          {
            'user' => {
              'email' => 'invalidemail'
            }
          }
        end

        let(:json_response) do
          {
            'errors' => {
              'email' => ['is invalid']
            }
          }
        end

        it 'returns unprocessable entity status' do
          request

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'return error messages' do
          request

          expect(JSON.parse(response.body)).to match(json_response)
        end
      end

      context 'when valid attributes' do
        let(:params) do
          {
            user: {
              username: 'lucas.silva',
              bio: 'new bio'
            }
          }
        end

        let(:json_response) do
          {
            'user' => {
              'id' => user.id,
              'email' => 'lucas@sample.com',
              'username' => 'lucas.silva',
              'bio' => 'new bio',
              'image' => nil,
              'token' => String
            }
          }
        end

        it 'returns status :ok' do
          request

          expect(response).to have_http_status(:ok)
        end

        it 'updates user attributes' do
          request

          expect(JSON.parse(response.body)).to match(json_response)
        end
      end
    end
  end
end
