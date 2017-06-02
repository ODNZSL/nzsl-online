class Indexes < ActiveRecord::Migration
  def change
    add_index :settings, :key
    add_index :page_parts, :page_id
    add_index :pages, :slug
    add_index :pages, :order
    add_index :items, :vocab_sheet_id
  end
end
