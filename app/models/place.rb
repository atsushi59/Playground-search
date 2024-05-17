class Place < ApplicationRecord
    belongs_to :user
    scope :by_user, -> (user) { where(user_id: user.id) }
    mount_uploader :photo_url, PlaceImageUploader
end
