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

ActiveRecord::Schema.define(:version => 20120311100131) do

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "dogs", :force => true do |t|
    t.string   "name"
    t.integer  "age"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "event_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "events", :force => true do |t|
    t.string   "title"
    t.string   "place"
    t.string   "speaker"
    t.string   "speakerInfo"
    t.integer  "school_id"
    t.string   "school_name"
    t.integer  "org_id"
    t.string   "org_name"
    t.string   "sponsor"
    t.string   "undertaker"
    t.string   "cooperater"
    t.integer  "seat"
    t.string   "brief"
    t.integer  "status"
    t.integer  "toward"
    t.text     "others"
    t.datetime "beginTime"
    t.datetime "endTime"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "known_users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "mobile"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "org_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "orgs", :force => true do |t|
    t.string   "name"
    t.integer  "org_type_id"
    t.string   "org_type_name"
    t.integer  "school_id"
    t.string   "school_name"
    t.integer  "events"
    t.integer  "followed"
    t.integer  "joined"
    t.string   "chairman"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "role_type_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "schools", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "titles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_events", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.integer  "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_orgs", :force => true do |t|
    t.integer  "user_id"
    t.integer  "org_id"
    t.integer  "role_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password"
    t.string   "mobile"
    t.integer  "workstate"
    t.integer  "school_id"
    t.string   "school"
    t.integer  "company_id"
    t.string   "company"
    t.integer  "title_id"
    t.string   "title"
    t.string   "portrait"
    t.text     "intro"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
