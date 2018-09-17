class AddEmailToFeedback < ActiveRecord::Migration[4.2]
  def self.up
    add_column :feedbacks, :email, :string
  end

  def self.down
    remove_column :feedbacks, :email
  end
end
