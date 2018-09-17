class AddPositionToItem < ActiveRecord::Migration[4.2]
  def self.up
    add_column :items, :position, :integer
  end

  def self.down
    remove_column :items, :position
  end
end
