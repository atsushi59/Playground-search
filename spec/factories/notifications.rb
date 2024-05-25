FactoryBot.define do
  factory :notification do
    review { nil }
    comment { nil }
    notification_type { "MyString" }
    read { false }
    visitor_id { 1 }
    visited_id { 1 }
  end
end
