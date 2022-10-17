# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:current_user) { create(:user) }

  describe '#favorite' do
    subject(:favorite) { current_user.favorite(article) }

    context 'when article was not favorited' do
      let(:article) { create(:article) }

      it 'favorites the article' do
        favorite

        expect(current_user.favorited?(article)).to be(true)
      end
    end

    context 'when article is already favorited' do
      let(:article) { create(:article) }

      before { current_user.favorite(article) }

      it 'keeps article favorited' do
        favorite

        expect(current_user.favorited?(article)).to be(true)
      end
    end
  end

  describe '#unfavorite' do
    subject(:unfavorite) { current_user.unfavorite(article) }

    context 'when article was not favorited' do
      let(:article) { create(:article) }

      it 'does nothing' do
        unfavorite

        expect(current_user.favorited?(article)).to be(false)
      end
    end

    context 'when article is already favorited' do
      let(:article) { create(:article) }

      before { current_user.favorite(article) }

      it 'unfavorites article' do
        unfavorite

        expect(current_user.favorited?(article)).to be(false)
      end
    end
  end

  describe '#favorited?' do
    subject { current_user.favorited?(article) }

    context 'when article was not favorited' do
      let(:article) { create(:article) }

      it { is_expected.to be(false) }
    end

    context 'when article is already favorited' do
      let(:article) { create(:article) }

      before { current_user.favorite(article) }

      it { is_expected.to be(true) }
    end
  end
end
