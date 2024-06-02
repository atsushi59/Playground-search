class RemoveFreeTextFromPlaces < ActiveRecord::Migration[7.1]
  def change
    remove_column :places, :free_text, :text
  end
end
