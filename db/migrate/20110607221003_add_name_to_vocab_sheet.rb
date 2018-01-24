class AddNameToVocabSheet < ActiveRecord::Migration
  def self.up
    add_column :vocab_sheets, :name, :string
  end

  def self.down
    remove_column :vocab_sheets, :name
  end
end
