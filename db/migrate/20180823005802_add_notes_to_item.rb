class AddNotesToItem < ActiveRecord::Migration
  def change
    add_index :items, :notes, :string, default: ''
  end
end
