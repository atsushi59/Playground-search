# frozen_string_literal: true

class CreatePlaces < ActiveRecord::Migration[7.1]
  def change
    create_table :places do |t|
      t.references :user, foreign_key: true
      t.string :name
      t.string :address
      t.string :website
      t.string :opening_hours
      t.string :photo_url
      t.string :activity_type
      t.text :free_text

      t.timestamps
    end
  end
end
