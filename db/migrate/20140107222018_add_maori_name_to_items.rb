class AddMaoriNameToItems < ActiveRecord::Migration
  def change
    add_column :items, :maori_name, :string
  end
end
