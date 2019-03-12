class AddNotesToItem < ActiveRecord::Migration[4.2]
  def change
    add_column :items, :notes, :string, null: false, default: ''
  end
end
