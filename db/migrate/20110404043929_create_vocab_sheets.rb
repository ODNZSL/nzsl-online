class CreateVocabSheets < ActiveRecord::Migration[4.2]
  def self.up
    create_table :vocab_sheets, &:timestamps
  end

  def self.down
    drop_table :vocab_sheets
  end
end
