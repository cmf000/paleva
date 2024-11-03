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

ActiveRecord::Schema[7.2].define(version: 2024_11_02_015250) do
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

  create_table "beverages", force: :cascade do |t|
    t.string "name", null: false
    t.string "description", null: false
    t.integer "calories"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "restaurant_id", null: false
    t.integer "alcoholic", null: false
    t.integer "status", default: 1
    t.index ["restaurant_id"], name: "index_beverages_on_restaurant_id"
  end

  create_table "dishes", force: :cascade do |t|
    t.string "name", null: false
    t.string "description", null: false
    t.integer "calories"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "restaurant_id", null: false
    t.integer "status", default: 1
    t.index ["restaurant_id"], name: "index_dishes_on_restaurant_id"
  end

  create_table "offerings", force: :cascade do |t|
    t.string "description", null: false
    t.string "offerable_type", null: false
    t.integer "offerable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "current_price", precision: 10, scale: 2, null: false
    t.datetime "effective_at", null: false
    t.index ["offerable_type", "offerable_id"], name: "index_offerings_on_offerable"
  end

  create_table "price_histories", force: :cascade do |t|
    t.decimal "price", null: false
    t.datetime "effective_at", null: false
    t.integer "offering_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["offering_id"], name: "index_price_histories_on_offering_id"
  end

  create_table "restaurants", force: :cascade do |t|
    t.string "registered_name", null: false
    t.string "trade_name", null: false
    t.string "cnpj", null: false
    t.string "street_address", null: false
    t.string "city", null: false
    t.string "state", null: false
    t.string "zip_code", null: false
    t.string "code", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "district", null: false
    t.string "email", null: false
    t.string "phone_number"
    t.index ["user_id"], name: "index_restaurants_on_user_id"
  end

  create_table "shifts", force: :cascade do |t|
    t.integer "weekday", null: false
    t.time "opening_time", null: false
    t.time "closing_time", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "restaurant_id", null: false
    t.index ["restaurant_id"], name: "index_shifts_on_restaurant_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cpf"
    t.string "name"
    t.integer "user_type", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "beverages", "restaurants"
  add_foreign_key "dishes", "restaurants"
  add_foreign_key "price_histories", "offerings"
  add_foreign_key "restaurants", "users"
  add_foreign_key "shifts", "restaurants"
end
