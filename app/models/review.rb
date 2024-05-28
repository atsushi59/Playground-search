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

  def create_notification_like!(current_user)
    temp = Notification.where(['visitor_id = ? and visited_id = ? and review_id = ? and notification_type = ?', current_user.id, user_id, id, 'like'])
    return unless temp.blank?

    notification = current_user.notifications_as_visitor.new(
      review_id: id,
      comment_id: nil,
      visited_id: user_id,
      notification_type: 'like'
    )
    notification.read = true if notification.visitor_id == notification.visited_id
    notification.save if notification.valid?
  end

  def create_notification_comment!(current_user, comment_id)
    temp_ids = Comment.select(:user_id).where(review_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, comment_id, temp_id['user_id'])
    end
    save_notification_comment!(current_user, comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_comment!(current_user, comment_id, visited_id)
    notification = current_user.notifications_as_visitor.new(
      review_id: id,
      comment_id:,
      visited_id:,
      notification_type: 'comment'
    )
    notification.read = true if notification.visitor_id == notification.visited_id
    notification.save if notification.valid?
  end
end
