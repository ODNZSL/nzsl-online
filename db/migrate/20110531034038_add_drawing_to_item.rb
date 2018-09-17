class AddDrawingToItem < ActiveRecord::Migration[4.2]
  def self.up
    add_column :items, :drawing, :string
  end

  def self.down
    remove_column :items, :drawing
  end
end
