class AddDrawingToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :drawing, :string
  end

  def self.down
    remove_column :items, :drawing
  end
end