class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.integer :sign_id, :null => false
      t.integer :vocab_sheet_id, :null => false
      t.string :name, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
