class Place < ApplicationRecord
    belongs_to :user
    has_many :place_favorites, dependent: :destroy
    mount_uploader :photo_url, PlaceImageUploader
end
