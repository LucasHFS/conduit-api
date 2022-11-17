FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.paragraphs.join(' ') }

    user
    article
  end
end
