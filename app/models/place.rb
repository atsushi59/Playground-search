# frozen_string_literal: true

class Place < ApplicationRecord
  belongs_to :user
  has_many :places_favorites, dependent: :destroy
  has_many :place_histories, dependent: :destroy
  has_many :reviews, dependent: :destroy
  mount_uploader :photo_url, PlaceImageUploader

  scope :with_reviews_by_user, ->(user_id) {
    joins(:reviews).includes(:reviews).where(reviews: { user_id: user_id }).distinct
  }
end
