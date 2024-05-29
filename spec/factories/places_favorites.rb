# frozen_string_literal: true

FactoryBot.define do
  factory :places_favorite do
    association :user
    association :place
  end
end