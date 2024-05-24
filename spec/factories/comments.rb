# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    user { nil }
    review { nil }
    body { 'MyText' }
  end
end
