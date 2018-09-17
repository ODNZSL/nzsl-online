class AddNameToVocabSheet < ActiveRecord::Migration[4.2]
  def self.up
    add_column :vocab_sheets, :name, :string
  end

  def self.down
    remove_column :vocab_sheets, :name
  end
end
