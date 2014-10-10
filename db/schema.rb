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

ActiveRecord::Schema.define(version: 20141010033119) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: true do |t|
    t.text     "content",          null: false
    t.integer  "commentable_id",   null: false
    t.string   "commentable_type", null: false
    t.integer  "user_id",          null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "hearts", force: true do |t|
    t.integer  "lovable_id",   null: false
    t.string   "lovable_type", null: false
    t.integer  "user_id",      null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "hearts", ["lovable_id", "lovable_type"], name: "index_hearts_on_lovable_id_and_lovable_type", using: :btree
  add_index "hearts", ["user_id", "lovable_id"], name: "index_hearts_on_user_id_and_lovable_id", using: :btree
  add_index "hearts", ["user_id"], name: "index_hearts_on_user_id", using: :btree

  create_table "photos", force: true do |t|
    t.integer  "photoable_id"
    t.string   "photoable_type"
    t.string   "image",          null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "photos", ["photoable_id", "photoable_type"], name: "index_photos_on_photoable_id_and_photoable_type", using: :btree

  create_table "posts", force: true do |t|
    t.text     "content",    null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",      null: false
    t.string   "first_name"
    t.string   "last_name"
    t.date     "birthday"
    t.string   "image"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree

end
