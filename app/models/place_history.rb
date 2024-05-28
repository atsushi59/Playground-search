# frozen_string_literal: true

class PlaceHistory < ApplicationRecord
  belongs_to :user
  belongs_to :place

  validates :user_id, uniqueness: { scope: :place_id }

  scope :by_place_ids, lambda { |place_ids|
    where(place_id: place_ids).includes(:place).order(created_at: :desc)
  }
end
