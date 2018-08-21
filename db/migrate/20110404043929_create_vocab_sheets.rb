class CreateVocabSheets < ActiveRecord::Migration
  def self.up
    create_table :vocab_sheets, &:timestamps
  end

  def self.down
    drop_table :vocab_sheets
  end
end
