# frozen_string_literal: true

FactoryBot.define do
  factory :review do
    user { nil }
    place { nil }
    body { 'MyText' }
    rating { 1 }
  end
end
