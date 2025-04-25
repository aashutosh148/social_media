FactoryBot.define do
  factory :post do
    user { nil }
    content { "MyText" }
    likes_count { 1 }
    comments_count { 1 }
  end
end
