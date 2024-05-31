class UpdateNullReadValuesInNotifications < ActiveRecord::Migration[7.1]
  def up
    execute "UPDATE notifications SET read = false WHERE read IS NULL"
  end
end
