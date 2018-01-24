class CreateVocabSheets < ActiveRecord::Migration
  def self.up
    create_table :vocab_sheets do |t|
      t.timestamps
    end
  end

  def self.down
    drop_table :vocab_sheets
  end
end
