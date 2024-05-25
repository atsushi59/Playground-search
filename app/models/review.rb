# frozen_string_literal: true

class Review < ApplicationRecord
  belongs_to :user
  belongs_to :place
  has_many :reviews_likes, dependent: :destroy
  has_many :review_favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy
  validates :body, presence: true
  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :user_id, uniqueness: { scope: :place_id }
end
