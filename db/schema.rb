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

ActiveRecord::Schema.define(:version => 20110212222402) do

  create_table "businesses", :force => true do |t|
    t.string   "short_name"
    t.string   "full_name"
    t.text     "description"
    t.text     "address"
    t.string   "email"
    t.string   "phone"
    t.string   "fax"
    t.string   "url"
    t.string   "facebook"
    t.string   "twitter"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "city"
    t.string   "postal_code"
    t.boolean  "publised"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
    t.boolean  "active",             :default => false
    t.string   "activation_key"
    t.string   "reset_password_key"
  end

end
