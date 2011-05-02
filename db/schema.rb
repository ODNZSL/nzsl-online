# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110501233715) do

  create_table "feedbacks", :force => true do |t|
    t.string   "name"
    t.text     "message"
    t.string   "video_file_name"
    t.integer  "video_file_size"
    t.string   "video_content_type"
    t.datetime "video_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
  end

  create_table "items", :force => true do |t|
    t.integer  "sign_id",        :null => false
    t.integer  "vocab_sheet_id", :null => false
    t.string   "name",           :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "vocab_sheets", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
