class CreateSearchLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :search_logs do |t|
      t.string :ip_address
      t.timestamps
    end
    add_index :search_logs, :ip_address
  end
end
