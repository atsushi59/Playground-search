# frozen_string_literal: true

FactoryBot.define do
  factory :review_favorite do
    user { nil }
    review { nil }
  end
end
