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

ActiveRecord::Schema.define(version: 20160427202652) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bars", force: :cascade do |t|
    t.string   "yelp_id"
    t.string   "name"
    t.integer  "freshness"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float    "lat"
    t.float    "lng"
    t.boolean  "is_current"
  end

  create_table "reports", force: :cascade do |t|
    t.integer  "line_length"
    t.float    "cover_charge"
    t.float    "ratio"
    t.float    "avg_age"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "bar_id"
    t.string   "user_id"
  end

  add_index "reports", ["bar_id"], name: "index_reports_on_bar_id", using: :btree
  add_index "reports", ["user_id"], name: "index_reports_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
