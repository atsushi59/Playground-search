# frozen_string_literal: true

class ChangeReadDefaultInNotifications < ActiveRecord::Migration[7.1]
  def change
    change_column_default :notifications, :read, from: nil, to: false
    change_column_null :notifications, :read, false
  end
end
