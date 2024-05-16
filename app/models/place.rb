class Place < ApplicationRecord
    belongs_to :user
    mount_uploader :photo_url, PlaceImageUploader
end
