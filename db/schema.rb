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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170918103918) do

  create_table "locations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "ip_address",                             null: false
    t.string  "country_code"
    t.string  "country",                                null: false
    t.string  "city",                                   null: false
    t.decimal "latitude",      precision: 10, scale: 6, null: false
    t.decimal "longitude",     precision: 10, scale: 6, null: false
    t.bigint  "mystery_value"
    t.index ["ip_address"], name: "index_locations_on_ip_address", unique: true, using: :btree
    t.index ["latitude", "longitude"], name: "locations_on_latitude_and_longitude", unique: true, using: :btree
  end

end
