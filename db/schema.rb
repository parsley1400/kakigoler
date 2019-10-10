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

ActiveRecord::Schema.define(version: 2019_10_03_115359) do

  create_table "contribution_tags", force: :cascade do |t|
    t.integer "tag_id"
    t.integer "contribution_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contribution_id"], name: "index_contribution_tags_on_contribution_id"
    t.index ["tag_id"], name: "index_contribution_tags_on_tag_id"
  end

  create_table "contributions", force: :cascade do |t|
    t.string "image"
    t.integer "sweet_id"
    t.integer "ice_id"
    t.integer "size_id"
    t.integer "plo_id"
    t.integer "price_id"
    t.string "store"
    t.string "icename"
    t.string "station"
    t.integer "user_id"
    t.boolean "favorite", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ice_id"], name: "index_contributions_on_ice_id"
    t.index ["plo_id"], name: "index_contributions_on_plo_id"
    t.index ["price_id"], name: "index_contributions_on_price_id"
    t.index ["size_id"], name: "index_contributions_on_size_id"
    t.index ["sweet_id"], name: "index_contributions_on_sweet_id"
    t.index ["user_id"], name: "index_contributions_on_user_id"
  end

  create_table "favorites", force: :cascade do |t|
    t.integer "user_id"
    t.integer "contribution_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contribution_id"], name: "index_favorites_on_contribution_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "ices", force: :cascade do |t|
    t.integer "ice_n", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plos", force: :cascade do |t|
    t.integer "plo_n", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sizes", force: :cascade do |t|
    t.integer "size_n", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sweets", force: :cascade do |t|
    t.integer "sweet_n", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
