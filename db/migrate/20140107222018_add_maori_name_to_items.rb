class AddMaoriNameToItems < ActiveRecord::Migration[4.2]
  def change
    add_column :items, :maori_name, :string
  end
end
