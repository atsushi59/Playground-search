# frozen_string_literal: true

class ReviewFavorite < ApplicationRecord
  belongs_to :user
  belongs_to :review

  validates :user_id, uniqueness: { scope: :review_id }
end
