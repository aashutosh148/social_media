FactoryBot.define do
  factory :user do
    username { Faker::Internet.unique.username(specifier: 5..20) }
    email { Faker::Internet.unique.email }
    password { "password123" }
    bio { Faker::Lorem.paragraph_by_chars(number: 150) }
    avatar_url { Faker::Avatar.image }
  end
end