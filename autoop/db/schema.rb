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

ActiveRecord::Schema[7.2].define(version: 2026_03_29_071430) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "vector"

  create_table "gl_codes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "quickbooks_id"
    t.string "name"
    t.string "account_type"
    t.string "account_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.vector "embedding", limit: 1536
    t.index ["user_id"], name: "index_gl_codes_on_user_id"
  end

  create_table "invoice_line_items", force: :cascade do |t|
    t.bigint "invoice_id", null: false
    t.bigint "gl_code_id", null: false
    t.text "description"
    t.decimal "amount"
    t.float "quantity"
    t.decimal "unit_price"
    t.float "confidence_score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gl_code_id"], name: "index_invoice_line_items_on_gl_code_id"
    t.index ["invoice_id"], name: "index_invoice_line_items_on_invoice_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "vendor_id", null: false
    t.string "status"
    t.decimal "total_amount"
    t.string "invoice_number"
    t.date "invoice_date"
    t.date "due_date"
    t.string "pdf_url"
    t.text "raw_text"
    t.float "confidence_score"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.vector "embedding", limit: 1536
    t.index ["user_id"], name: "index_invoices_on_user_id"
    t.index ["vendor_id"], name: "index_invoices_on_vendor_id"
  end

  create_table "quick_books_connections", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "access_token"
    t.text "refresh_token"
    t.datetime "token_expires_at"
    t.string "realm_id"
    t.boolean "connected"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_quick_books_connections_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "company_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vendors", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "quickbooks_id"
    t.string "name"
    t.string "email"
    t.string "phone"
    t.text "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_vendors_on_user_id"
  end

  add_foreign_key "gl_codes", "users"
  add_foreign_key "invoice_line_items", "gl_codes"
  add_foreign_key "invoice_line_items", "invoices"
  add_foreign_key "invoices", "users"
  add_foreign_key "invoices", "vendors"
  add_foreign_key "quick_books_connections", "users"
  add_foreign_key "vendors", "users"
end
