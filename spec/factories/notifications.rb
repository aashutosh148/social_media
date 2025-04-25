FactoryBot.define do
  factory :notification do
    recipient { "" }
    actor { "" }
    action { "MyString" }
    notifiable { "" }
    read { false }
  end
end
