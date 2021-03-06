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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120925215310) do

  create_table "credentials", :force => true do |t|
    t.string   "username"
    t.string   "hash"
    t.string   "password"
    t.string   "email"
    t.integer  "leak_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "credentials", ["leak_id", "password"], :name => "index_credentials_on_leak_id_and_password"
  add_index "credentials", ["leak_id"], :name => "index_credentials_on_leak_id"
  add_index "credentials", ["password"], :name => "index_credentials_on_password"

  create_table "leaks", :force => true do |t|
    t.string   "address"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "stats"
    t.datetime "leaked_on"
  end

  create_table "stat_overviews", :force => true do |t|
    t.text     "strength_points"
    t.text     "length_points"
    t.text     "complexity_points"
    t.text     "length_distribution"
    t.text     "strength_distribution"
    t.text     "complexity_distribution"
    t.text     "most_common_passwords"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
