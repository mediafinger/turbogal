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

ActiveRecord::Schema.define(version: 20150425141710) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "images", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "image"
    t.string   "format"
    t.integer  "height"
    t.integer  "width"
    t.integer  "size"
    t.string   "filename"
    t.string   "name"
    t.string   "location"
    t.text     "description"
    t.date     "date"
    t.datetime "taken_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "images", ["user_id"], name: "index_images_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",                            null: false
    t.string   "email",                           null: false
    t.boolean  "confirmed",       default: false
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree

end
