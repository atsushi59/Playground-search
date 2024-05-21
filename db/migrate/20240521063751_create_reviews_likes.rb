class CreateReviewsLikes < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews_likes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :review, null: false, foreign_key: true

      t.timestamps
    end
  end
end
