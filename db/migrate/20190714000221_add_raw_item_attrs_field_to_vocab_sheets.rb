class AddRawItemAttrsFieldToVocabSheets < ActiveRecord::Migration[5.2]
  def change
    add_column :vocab_sheets, :raw_item_attrs, :jsonb, null: false, default: []
  end
end
