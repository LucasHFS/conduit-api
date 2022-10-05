# frozen_string_literal: true

FactoryBot.define do
  factory :article do
    title { Faker::Book.title }
    description { Faker::Lorem.paragraph }
    body { Faker::Lorem.paragraphs.join(' ') }

    user
  end
end
