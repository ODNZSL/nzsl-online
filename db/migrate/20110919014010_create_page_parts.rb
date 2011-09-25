class CreatePageParts < ActiveRecord::Migration
  def self.up
    create_table :page_parts do |t|
      t.string :title
      t.integer :order
      t.text :body
      t.string :translation_path
      t.integer :page_id

      t.timestamps
    end
  end

  def self.down
    drop_table :page_parts
  end
end
