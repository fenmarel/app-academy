# encoding: UTF-8
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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140218055459) do

  create_table "statuses", force: true do |t|
    t.string "body"
    t.string "twitter_status_id"
    t.string "twitter_user_id"
  end

  add_index "statuses", ["twitter_status_id"], name: "index_statuses_on_twitter_status_id", unique: true
  add_index "statuses", ["twitter_user_id"], name: "index_statuses_on_twitter_user_id"

  create_table "users", force: true do |t|
    t.string "screen_name"
    t.string "twitter_user_id"
  end

  add_index "users", ["screen_name"], name: "index_users_on_screen_name", unique: true
  add_index "users", ["twitter_user_id"], name: "index_users_on_twitter_user_id", unique: true

end
