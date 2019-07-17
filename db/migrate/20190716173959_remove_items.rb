class RemoveItems < ActiveRecord::Migration[5.2]
  def change
    drop_table :items do |t|
      t.integer 'sign_id', null: false
      t.integer 'vocab_sheet_id', null: false
      t.string 'name', null: false
      t.datetime 'created_at'
      t.datetime 'updated_at'
      t.integer 'position'
      t.string 'drawing'
      t.string 'maori_name'
      t.string 'notes', default: '', null: false
    end
  end
end
