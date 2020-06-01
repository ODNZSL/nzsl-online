class AddUniqueIndexToSlugInPages < ActiveRecord::Migration[5.2]
  def change
    remove_index(:pages, :slug)
    add_index(:pages, :slug, unique: true)
  end
end
