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

ActiveRecord::Schema[7.0].define(version: 2023_10_20_173413) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accessible_products", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.bigint "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id", "product_id"], name: "index_accessible_products_on_client_id_and_product_id", unique: true
    t.index ["client_id"], name: "index_accessible_products_on_client_id"
    t.index ["product_id"], name: "index_accessible_products_on_product_id"
  end

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
    t.string "name", null: false
    t.index ["confirmation_token"], name: "index_admins_on_confirmation_token", unique: true
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "brands", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "admin_id", null: false
    t.integer "status", default: 0
    t.index ["admin_id"], name: "index_brands_on_admin_id"
  end

  create_table "cards", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "client_id", null: false
    t.string "activation_code", null: false
    t.integer "status", default: 0
    t.string "purchase_pin", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.string "currency", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "admin_id"
    t.decimal "usd_price", precision: 10, scale: 2, null: false
    t.index ["activation_code"], name: "index_cards_on_activation_code", unique: true
    t.index ["admin_id"], name: "index_cards_on_admin_id"
    t.index ["client_id"], name: "index_cards_on_client_id"
    t.index ["product_id"], name: "index_cards_on_product_id"
    t.index ["purchase_pin"], name: "index_cards_on_purchase_pin", unique: true
  end

  create_table "clients", force: :cascade do |t|
    t.string "username", null: false
    t.string "name", null: false
    t.string "password_digest", null: false
    t.float "payout_rate", default: 0.0
    t.float "balance", default: 0.0
    t.bigint "admin_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_clients_on_admin_id"
    t.index ["username"], name: "index_clients_on_username", unique: true
  end

  create_table "currencies", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_currencies_on_name", unique: true
  end

  create_table "custom_fields", force: :cascade do |t|
    t.string "name", null: false
    t.string "value", null: false
    t.string "custom_fieldable_type", null: false
    t.bigint "custom_fieldable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["custom_fieldable_type", "custom_fieldable_id"], name: "index_custom_fields_on_custom_fieldable"
  end

  create_table "devices", force: :cascade do |t|
    t.string "secret", null: false
    t.string "device_id", null: false
    t.bigint "client_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_devices_on_client_id"
    t.index ["device_id"], name: "index_devices_on_device_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "brand_id", null: false
    t.integer "status", default: 0
    t.decimal "price", precision: 10, scale: 2, null: false
    t.bigint "admin_id", null: false
    t.integer "stock", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "currency"
    t.decimal "usd_price", precision: 10, scale: 2, null: false
    t.index ["admin_id"], name: "index_products_on_admin_id"
    t.index ["brand_id"], name: "index_products_on_brand_id"
  end

  add_foreign_key "accessible_products", "clients"
  add_foreign_key "accessible_products", "products"
  add_foreign_key "brands", "admins"
  add_foreign_key "cards", "admins"
  add_foreign_key "cards", "clients"
  add_foreign_key "cards", "products"
  add_foreign_key "clients", "admins"
  add_foreign_key "devices", "clients"
  add_foreign_key "products", "admins"
  add_foreign_key "products", "brands"
end
