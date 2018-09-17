class CreateFeedbacks < ActiveRecord::Migration[4.2]
  def self.up
    create_table :feedbacks do |t|
      t.string :name
      t.text :message
      t.string :video_file_name
      t.integer :video_file_size
      t.string :video_content_type
      t.datetime :video_updated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :feedbacks
  end
end
