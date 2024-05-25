# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :review
  has_many :notifications, dependent: :destroy
  validates :body, presence: true
end
