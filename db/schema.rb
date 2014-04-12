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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140411232017) do

  create_table "active_games", force: true do |t|
    t.integer  "player_id"
    t.integer  "p1_score"
    t.integer  "p2_score"
    t.integer  "num_hands"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "active_hands", force: true do |t|
    t.integer  "player_id"
    t.string   "p1_hand"
    t.string   "p2_hand"
    t.boolean  "dealer"
    t.string   "crib_hand"
    t.string   "peg_stack"
    t.integer  "peg_sum"
    t.integer  "active_game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "workflow_state"
    t.string   "cut_card"
  end

  create_table "crib_players", force: true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "game_stats", force: true do |t|
    t.integer  "crib_player_id"
    t.integer  "ai_id"
    t.integer  "user_score"
    t.integer  "ai_score"
    t.integer  "hands_played"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "player_stats", force: true do |t|
    t.integer  "crib_player_id"
    t.integer  "games_played"
    t.integer  "games_won"
    t.integer  "skunks"
    t.string   "best_hand"
    t.string   "best_peg"
    t.integer  "lowest_ai_score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
