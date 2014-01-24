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

ActiveRecord::Schema.define(version: 20140112171809) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "builds", force: true do |t|
    t.integer  "build_id"
    t.integer  "passed_count",  default: 0, null: false
    t.integer  "failed_count",  default: 0, null: false
    t.integer  "pending_count", default: 0, null: false
    t.integer  "total_count",   default: 0, null: false
    t.string   "status"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.float    "duration"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "builds", ["build_id"], name: "index_builds_on_build_id", unique: true, using: :btree

  create_table "tests", force: true do |t|
    t.integer  "build_id"
    t.string   "status"
    t.text     "test_group"
    t.text     "description"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.float    "runtime"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tests", ["build_id"], name: "index_tests_on_build_id", using: :btree

end
