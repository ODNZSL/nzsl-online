class AddFieldsToFeedback < ActiveRecord::Migration[4.2]
  def self.up
    add_column :feedbacks, :hearing_level, :string
    add_column :feedbacks, :nzsl_level, :string
    add_column :feedbacks, :include_sign, :boolean
    add_column :feedbacks, :include_describe, :string
    add_column :feedbacks, :include_define, :string
    add_column :feedbacks, :include_users, :string
    add_column :feedbacks, :include_comments, :text
    add_column :feedbacks, :change_sign, :boolean
    add_column :feedbacks, :change_sign_gloss, :string
    add_column :feedbacks, :change_sign_url, :string
    add_column :feedbacks, :change_sign_entry, :string
    add_column :feedbacks, :change_comments, :text
    add_column :feedbacks, :technical_fault, :boolean
  end

  def self.down
    remove_column :feedbacks, :technical_fault
    remove_column :feedbacks, :comments
    remove_column :feedbacks, :sign_entry
    remove_column :feedbacks, :sign_url
    remove_column :feedbacks, :main_gloss
    remove_column :feedbacks, :change_sign
    remove_column :feedbacks, :other_comments
    remove_column :feedbacks, :column_name
    remove_column :feedbacks, :show_sign
    remove_column :feedbacks, :include_sign
    remove_column :feedbacks, :nzsl_level
    remove_column :feedbacks, :column_name
  end
end
