class CreateSitemaps < ActiveRecord::Migration[5.2]
  def change
    create_table :sitemaps do |t|
      t.text :xmldump
      
      t.timestamps
    end
  end
end
