# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Health', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get '/api/v1/health', headers: { 'Accept' => 'application/json' }

      expect(response).to have_http_status(:ok)
    end
  end
end
