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

ActiveRecord::Schema.define(version: 20150318162827) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.integer  "conference_id"
    t.text     "body"
    t.integer  "user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "comments", ["conference_id"], name: "index_comments_on_conference_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "conferences", force: :cascade do |t|
    t.string   "title"
    t.string   "url"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "creation_user_id"
    t.string   "location"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "slug"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "city_state"
    t.integer  "followings_count"
  end

  add_index "conferences", ["creation_user_id"], name: "index_conferences_on_creation_user_id", using: :btree
  add_index "conferences", ["end_date"], name: "index_conferences_on_end_date", using: :btree
  add_index "conferences", ["location"], name: "index_conferences_on_location", using: :btree
  add_index "conferences", ["slug"], name: "index_conferences_on_slug", using: :btree
  add_index "conferences", ["start_date"], name: "index_conferences_on_start_date", using: :btree

  create_table "followings", force: :cascade do |t|
    t.integer  "conference_id", null: false
    t.integer  "user_id",       null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "followings", ["conference_id"], name: "index_followings_on_conference_id", using: :btree
  add_index "followings", ["user_id"], name: "index_followings_on_user_id", using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "omniauth_accounts", force: :cascade do |t|
    t.string   "uid",        default: "", null: false
    t.string   "provider",   default: "", null: false
    t.integer  "user_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "omniauth_accounts", ["provider", "uid"], name: "index_omniauth_accounts_on_provider_and_uid", using: :btree
  add_index "omniauth_accounts", ["user_id"], name: "index_omniauth_accounts_on_user_id", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",               default: ""
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.string   "name"
    t.boolean  "admin",               default: false
    t.string   "slug"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  add_foreign_key "comments", "users"
end
