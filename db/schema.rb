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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110425142421) do

  create_table "appointments", :force => true do |t|
    t.integer  "user_id"
    t.datetime "start_date"
    t.integer  "duration"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "availabilities", :force => true do |t|
    t.text     "json_data"
    t.integer  "availabilityable_id"
    t.string   "availabilityable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "exceptions_json_data"
  end

  create_table "business_account_specialities", :force => true do |t|
    t.integer  "business_account_id"
    t.integer  "speciality_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "business_accounts", :force => true do |t|
    t.integer  "created_by_business_admin_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "businesses", :force => true do |t|
    t.string   "short_name"
    t.string   "full_name"
    t.text     "description"
    t.text     "address"
    t.string   "city"
    t.string   "postal_code"
    t.string   "email"
    t.string   "phone"
    t.string   "fax"
    t.string   "url"
    t.string   "facebook"
    t.string   "twitter"
    t.integer  "business_account_id"
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "specialities", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "specialities", ["name"], :name => "index_specialities_on_name"

  create_table "staffer_specialities", :force => true do |t|
    t.integer  "staffer_id"
    t.integer  "speciality_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "active",              :default => false
    t.string   "activation_key"
    t.string   "reset_password_key"
    t.string   "phone"
    t.string   "type"
    t.text     "address"
    t.string   "postal_code"
    t.string   "city"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "business_account_id"
    t.boolean  "need_new_password",   :default => false
    t.integer  "created_by"
  end

end
