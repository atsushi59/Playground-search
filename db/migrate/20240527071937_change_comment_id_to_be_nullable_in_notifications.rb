# frozen_string_literal: true

class ChangeCommentIdToBeNullableInNotifications < ActiveRecord::Migration[7.1]
  def change
    change_column_null :notifications, :comment_id, true
  end
end
