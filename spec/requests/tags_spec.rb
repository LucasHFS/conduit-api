# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tags', type: :request do
  describe 'get /index' do
    subject(:request) { get '/api/tags' }

    let!(:article1) { create(:article, tag_list: %w[coding tests]) }
    let!(:article2) { create(:article, tag_list: %w[dragons training]) }

    let(:json_response) do
      {
        'tags' => %w[coding tests dragons training]
      }
    end

    it 'returns ok status' do
      request

      expect(response).to have_http_status(:ok)
    end

    it 'returns tags' do
      request

      expect(JSON.parse(response.body)).to match(json_response)
    end
  end
end
