# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_01_05_204215) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agendas", force: :cascade do |t|
    t.bigint "room_id"
    t.bigint "office_id"
    t.integer "start_time", null: false
    t.integer "amount_of_hours", default: 1
    t.date "reserve_date", null: false
    t.string "reserve_name", null: false
    t.string "token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["office_id"], name: "index_agendas_on_office_id"
    t.index ["room_id"], name: "index_agendas_on_room_id"
  end

  create_table "offices", force: :cascade do |t|
    t.integer "capacity", default: 4
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "rooms", force: :cascade do |t|
    t.bigint "office_id"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["office_id"], name: "index_rooms_on_office_id"
  end

  add_foreign_key "agendas", "offices"
  add_foreign_key "agendas", "rooms"
  add_foreign_key "rooms", "offices"
end
