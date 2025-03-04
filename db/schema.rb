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

ActiveRecord::Schema[8.0].define(version: 2025_03_03_195533) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "admins", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.boolean "canEditDatabase", default: true
    t.index ["user_id"], name: "index_admins_on_user_id"
  end

  create_table "comments", primary_key: "comment_id", force: :cascade do |t|
    t.bigint "parent_post_id", null: false
    t.text "content", null: false
    t.bigint "sending_user_id", null: false
    t.index ["parent_post_id"], name: "index_comments_on_parent_post_id"
    t.index ["sending_user_id"], name: "index_comments_on_sending_user_id"
  end

  create_table "physician_specialties", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "specialty_id"
    t.index ["specialty_id"], name: "index_physician_specialties_on_specialty_id"
    t.index ["user_id"], name: "index_physician_specialties_on_user_id"
  end

  create_table "post_specialties", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.bigint "specialty_id", null: false
    t.index ["post_id"], name: "index_post_specialties_on_post_id"
    t.index ["specialty_id"], name: "index_post_specialties_on_specialty_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.bigint "sending_user_id"
    t.bigint "post_id"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["sending_user_id"], name: "index_posts_on_sending_user_id"
  end

  create_table "specialties", force: :cascade do |t|
    t.string "name"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider"
    t.string "email"
    t.string "last_name"
    t.string "first_name"
    t.string "password_digest"
    t.string "location"
    t.date "DOB"
    t.string "phone_number"
    t.string "profile_image_url"
    t.boolean "isProfessional"
    t.bigint "user_id"
  end

  add_foreign_key "admins", "users"
  add_foreign_key "comments", "posts", column: "parent_post_id"
  add_foreign_key "comments", "users", column: "sending_user_id"
  add_foreign_key "physician_specialties", "specialties"
  add_foreign_key "physician_specialties", "users"
  add_foreign_key "post_specialties", "posts"
  add_foreign_key "post_specialties", "specialties"
  add_foreign_key "posts", "users", column: "sending_user_id"
end
