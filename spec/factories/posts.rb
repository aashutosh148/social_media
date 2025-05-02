FactoryBot.define do
  factory :post do
    user
    content { Faker::Lorem.paragraph_by_chars(number: 200) }
    likes_count { 0 }
    comments_count { 0 }
  end
end