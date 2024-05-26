class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.integer :visitor_id, null: false
      t.integer :visited_id, null: false
      t.references :review, foreign_key: true
      t.references :comment, foreign_key: true
      t.string :notification_type, null: false
      t.boolean :read, default: false

      t.timestamps
    end
  end
end
