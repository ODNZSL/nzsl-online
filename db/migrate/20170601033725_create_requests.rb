class CreateRequests < ActiveRecord::Migration[4.2]
  def change
    create_table :requests do |t|
      t.text :url
      t.float :elapsed_time
      t.integer :count
      t.text :query_type
      t.timestamps null: false
    end
  end
end
