# frozen_string_literal: true

class PlacesFavorite < ApplicationRecord
  belongs_to :user
  belongs_to :place

  validates :user_id, uniqueness: { scope: :place_id }
end
