# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_08_12_152155) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "episodes", force: :cascade do |t|
    t.integer "owner_id"
    t.integer "podcast_id", null: false
    t.string "title", default: "", null: false
    t.text "description", default: "", null: false
    t.json "metadata", default: {}, null: false
    t.datetime "published_at"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_episodes_on_owner_id"
    t.index ["podcast_id"], name: "index_episodes_on_podcast_id"
    t.check_constraint "json_type(metadata) = 'object'", name: "chk_metadata_is_object"
  end

  create_table "feeds", force: :cascade do |t|
    t.integer "server_id", null: false
    t.integer "podcast_id", null: false
    t.string "url", null: false
    t.string "path", null: false
    t.datetime "last_upload_at"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["podcast_id"], name: "index_feeds_on_podcast_id"
    t.index ["server_id"], name: "index_feeds_on_server_id"
  end

  create_table "podcasts", force: :cascade do |t|
    t.integer "owner_id"
    t.string "title", default: "", null: false
    t.text "description", default: "", null: false
    t.datetime "published_at"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_podcasts_on_owner_id"
  end

  create_table "servers", force: :cascade do |t|
    t.integer "owner_id"
    t.string "name"
    t.string "host", null: false
    t.integer "port", default: 22, null: false
    t.string "user", null: false
    t.text "private_key", null: false
    t.string "host_key"
    t.datetime "last_login_at"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_servers_on_owner_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.boolean "admin", default: false, null: false
    t.datetime "verified_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "episodes", "podcasts", on_delete: :cascade
  add_foreign_key "episodes", "users", column: "owner_id", on_delete: :nullify
  add_foreign_key "feeds", "podcasts", on_delete: :restrict
  add_foreign_key "feeds", "servers", on_delete: :restrict
  add_foreign_key "podcasts", "users", column: "owner_id", on_delete: :nullify
  add_foreign_key "servers", "users", column: "owner_id", on_delete: :nullify
  add_foreign_key "sessions", "users", on_delete: :cascade
end
