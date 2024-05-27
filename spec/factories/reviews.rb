# frozen_string_literal: true

FactoryBot.define do
  factory :review do
    association :user
    association :place
    body { "Sample review body" }
    rating { 4 }
  end
end