# frozen_string_literal: true

FactoryBot.define do
  factory :place do
    association :user
    name { '東京駅' }
    address { '東京都千代田区丸の内一丁目９番１号' }
    website { 'https://example.com' }
    opening_hours { '9:00 - 17:00' }
    photo_url { 'https://example.com/photo.jpg' }
    activity_type { '公園' }
  end
end
