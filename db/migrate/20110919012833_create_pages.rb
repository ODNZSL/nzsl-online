class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :title
      t.string :slug
      t.string :label
      t.integer :order
      t.string :template
      t.boolean :show_in_nav

      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end
