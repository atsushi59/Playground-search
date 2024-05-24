# frozen_string_literal: true

class ReviewsLike < ApplicationRecord
  belongs_to :user
  belongs_to :review

  validates :user_id, uniqueness: { scope: :review_id }
end
