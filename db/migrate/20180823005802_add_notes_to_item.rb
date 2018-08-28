class AddNotesToItem < ActiveRecord::Migration
  def change
    add_column :items, :notes, :string, null: false, default: ''
  end
end
