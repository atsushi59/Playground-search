class Place < ApplicationRecord
    belongs_to :user
    has_many :places_favorites, dependent: :destroy
    has_many :place_histories, dependent: :destroy
    mount_uploader :photo_url, PlaceImageUploader
end
