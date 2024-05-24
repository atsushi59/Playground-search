# frozen_string_literal: true

class CreateSnsCredentials < ActiveRecord::Migration[7.1]
  def change
    create_table :sns_credentials do |t|
      t.string :provider
      t.string :uid
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
