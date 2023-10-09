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

ActiveRecord::Schema[7.0].define(version: 2023_10_08_224957) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", limit: 10, null: false
    t.index ["confirmation_token"], name: "index_admins_on_confirmation_token", unique: true
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "brands", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "admin_id", null: false
    t.integer "status", default: 0
    t.index ["admin_id"], name: "index_brands_on_admin_id"
  end

  create_table "currencies", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "custom_fields", force: :cascade do |t|
    t.string "name"
    t.string "value"
    t.string "custom_fieldable_type", null: false
    t.bigint "custom_fieldable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["custom_fieldable_type", "custom_fieldable_id"], name: "index_custom_fields_on_custom_fieldable"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.bigint "brand_id", null: false
    t.integer "status"
    t.float "price"
    t.bigint "currency_id", null: false
    t.bigint "admin_id", null: false
    t.integer "stock"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_products_on_admin_id"
    t.index ["brand_id"], name: "index_products_on_brand_id"
    t.index ["currency_id"], name: "index_products_on_currency_id"
  end

  add_foreign_key "brands", "admins"
  add_foreign_key "products", "admins"
  add_foreign_key "products", "brands"
  add_foreign_key "products", "currencies"
end