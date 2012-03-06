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

ActiveRecord::Schema.define(:version => 20120306230015) do

  create_table "camps", :force => true do |t|
    t.string   "name"
    t.integer  "company_id"
    t.integer  "location_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "drives", :force => true do |t|
    t.string   "route"
    t.float    "duration_hr"
    t.float    "distance_km"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
    t.spatial  "polygon",    :limit => {:srid=>0, :type=>"geometry"}
  end

  create_table "sightings", :force => true do |t|
    t.integer  "species_id"
    t.integer  "tribe_id"
    t.integer  "location_id"
    t.integer  "drive_id"
    t.string   "description"
    t.integer  "user_id"
    t.string   "submission_point"
    t.datetime "record_time"
    t.integer  "time_window_hr"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "camp_id"
  end

  create_table "species", :force => true do |t|
    t.string   "common_name"
    t.string   "binomial"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "tribes", :force => true do |t|
    t.string   "name"
    t.integer  "location_id"
    t.integer  "species_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

end
