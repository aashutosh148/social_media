FactoryBot.define do
  factory :notification do
    action { ["like", "comment", "follow"].sample }
    read { false }
    
    trait :for_post do
      association :notifiable, factory: :post
    end
    
    trait :for_comment do
      association :notifiable, factory: :comment
    end
    
    trait :for_follow do
      association :notifiable, factory: :follow
    end
  end
end