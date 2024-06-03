# frozen_string_literal: true

FactoryBot.define do
  factory :review do
    association :user
    association :place
    body { '素晴らしい場所です' }
    rating { 4 }
  end
end
