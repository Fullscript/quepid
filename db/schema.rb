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

ActiveRecord::Schema[7.0].define(version: 2023_09_07_102331) do
  create_table "annotations", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.text "message"
    t.string "source"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_annotations_on_user_id"
  end

  create_table "api_keys", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.integer "user_id"
    t.string "token_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token_digest"], name: "index_api_keys_on_token_digest"
  end

  create_table "books", charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.integer "team_id"
    t.integer "scorer_id"
    t.bigint "selection_strategy_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "support_implicit_judgements"
    t.boolean "show_rank", default: false
    t.index ["selection_strategy_id"], name: "index_books_on_selection_strategy_id"
  end

  create_table "case_metadata", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "case_id", null: false
    t.datetime "last_viewed_at"
    t.index ["case_id"], name: "case_metadata_ibfk_1"
    t.index ["user_id", "case_id"], name: "case_metadata_user_id_case_id_index"
  end

  create_table "case_scores", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "case_id"
    t.integer "user_id"
    t.integer "try_id"
    t.float "score"
    t.boolean "all_rated"
    t.datetime "created_at"
    t.binary "queries", size: :medium
    t.integer "annotation_id"
    t.datetime "updated_at"
    t.index ["annotation_id"], name: "index_case_scores_on_annotation_id"
    t.index ["case_id"], name: "case_id"
    t.index ["user_id"], name: "user_id"
  end

  create_table "cases", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.string "case_name", limit: 191
    t.integer "last_try_number"
    t.integer "owner_id"
    t.boolean "archived"
    t.integer "scorer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "book_id"
    t.boolean "public"
    t.index ["owner_id"], name: "user_id"
  end

  create_table "curator_variables", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name", limit: 500
    t.float "value"
    t.integer "try_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["try_id"], name: "try_id"
  end

  create_table "judgements", charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.integer "user_id"
    t.float "rating"
    t.bigint "query_doc_pair_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "unrateable", default: false
    t.index ["query_doc_pair_id"], name: "index_judgements_on_query_doc_pair_id"
    t.index ["user_id", "query_doc_pair_id"], name: "index_judgements_on_user_id_and_query_doc_pair_id", unique: true
  end

  create_table "permissions", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.integer "user_id"
    t.string "model_type", null: false
    t.string "action", null: false
    t.boolean "on", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "queries", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.bigint "arranged_next"
    t.bigint "arranged_at"
    t.string "query_text", limit: 500
    t.text "notes"
    t.float "threshold"
    t.boolean "threshold_enbl"
    t.integer "case_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "options"
    t.string "information_need"
    t.index ["case_id"], name: "case_id"
  end

  create_table "query_doc_pairs", charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "query_text", limit: 500
    t.integer "position"
    t.text "document_fields"
    t.bigint "book_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "doc_id", limit: 500
    t.index ["book_id"], name: "index_query_doc_pairs_on_book_id"
  end

  create_table "ratings", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "doc_id", limit: 500
    t.float "rating"
    t.integer "query_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["doc_id"], name: "index_ratings_on_doc_id", length: 191
    t.index ["query_id"], name: "query_id"
  end

  create_table "scorers", id: :integer, charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.text "code"
    t.string "name"
    t.integer "owner_id"
    t.string "scale"
    t.boolean "show_scale_labels", default: false
    t.text "scale_with_labels"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "communal", default: false
  end

  create_table "selection_strategies", charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
  end

  create_table "snapshot_docs", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "doc_id", limit: 500
    t.integer "position"
    t.integer "snapshot_query_id"
    t.text "explain", size: :medium, collation: "utf8mb4_0900_ai_ci"
    t.boolean "rated_only", default: false
    t.text "fields", size: :medium, collation: "utf8mb4_0900_ai_ci"
    t.index ["snapshot_query_id"], name: "snapshot_query_id"
  end

  create_table "snapshot_queries", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "query_id"
    t.integer "snapshot_id"
    t.float "score"
    t.boolean "all_rated"
    t.integer "number_of_results"
    t.index ["query_id"], name: "query_id"
    t.index ["snapshot_id"], name: "snapshot_id"
  end

  create_table "snapshots", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name", limit: 250
    t.datetime "created_at"
    t.integer "case_id"
    t.datetime "updated_at", null: false
    t.bigint "try_id"
    t.bigint "scorer_id"
    t.index ["case_id"], name: "case_id"
    t.index ["scorer_id"], name: "index_snapshots_on_scorer_id"
    t.index ["try_id"], name: "index_snapshots_on_try_id"
  end

  create_table "teams", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name", collation: "utf8mb3_bin"
    t.integer "owner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_teams_on_name", length: 191
    t.index ["owner_id"], name: "owner_id"
  end

  create_table "teams_cases", primary_key: ["case_id", "team_id"], charset: "latin1", force: :cascade do |t|
    t.integer "case_id", null: false
    t.integer "team_id", null: false
    t.index ["case_id"], name: "index_teams_cases_on_case_id"
    t.index ["team_id"], name: "index_teams_cases_on_team_id"
  end

  create_table "teams_members", primary_key: ["member_id", "team_id"], charset: "latin1", force: :cascade do |t|
    t.integer "member_id", null: false
    t.integer "team_id", null: false
    t.index ["member_id"], name: "index_teams_members_on_member_id"
    t.index ["team_id"], name: "index_teams_members_on_team_id"
  end

  create_table "teams_scorers", primary_key: ["scorer_id", "team_id"], charset: "latin1", force: :cascade do |t|
    t.integer "scorer_id", null: false
    t.integer "team_id", null: false
    t.index ["scorer_id"], name: "index_teams_scorers_on_scorer_id"
    t.index ["team_id"], name: "index_teams_scorers_on_team_id"
  end

  create_table "tries", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "try_number"
    t.string "query_params", limit: 20000
    t.integer "case_id"
    t.string "field_spec", limit: 500
    t.string "search_url", limit: 500
    t.string "name", limit: 50
    t.string "search_engine", limit: 50, default: "solr"
    t.boolean "escape_query", default: true
    t.integer "number_of_rows", default: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ancestry", limit: 3072
    t.string "api_method"
    t.string "custom_headers", limit: 1000
    t.index ["case_id"], name: "case_id"
    t.index ["try_number"], name: "ix_queryparam_tryNo"
  end

  create_table "users", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "email", limit: 80
    t.string "password", limit: 120
    t.datetime "agreed_time"
    t.boolean "agreed"
    t.integer "num_logins"
    t.string "name"
    t.boolean "administrator", default: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string "company"
    t.boolean "locked"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "default_scorer_id"
    t.boolean "email_marketing", default: false, null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.integer "invited_by_id"
    t.integer "invitations_count", default: 0
    t.boolean "completed_case_wizard", default: false, null: false
    t.string "stored_raw_invitation_token"
    t.string "profile_pic"
    t.index ["default_scorer_id"], name: "index_users_on_default_scorer_id"
    t.index ["email"], name: "ix_user_username", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true, length: 191
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["name"], name: "index_users_on_name"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, length: 191
  end

  add_foreign_key "annotations", "users"
  add_foreign_key "books", "selection_strategies"
  add_foreign_key "case_metadata", "cases", name: "case_metadata_ibfk_1"
  add_foreign_key "case_metadata", "users", name: "case_metadata_ibfk_2"
  add_foreign_key "case_scores", "annotations"
  add_foreign_key "case_scores", "cases", name: "case_scores_ibfk_1"
  add_foreign_key "case_scores", "users", name: "case_scores_ibfk_2"
  add_foreign_key "cases", "users", column: "owner_id", name: "cases_ibfk_1"
  add_foreign_key "judgements", "query_doc_pairs"
  add_foreign_key "queries", "cases", name: "queries_ibfk_1"
  add_foreign_key "query_doc_pairs", "books"
  add_foreign_key "ratings", "queries", name: "ratings_ibfk_1"
  add_foreign_key "snapshot_docs", "snapshot_queries", name: "snapshot_docs_ibfk_1"
  add_foreign_key "snapshot_queries", "queries", name: "snapshot_queries_ibfk_1"
  add_foreign_key "snapshot_queries", "snapshots", name: "snapshot_queries_ibfk_2"
  add_foreign_key "snapshots", "cases", name: "snapshots_ibfk_1"
  add_foreign_key "teams", "users", column: "owner_id", name: "teams_ibfk_1"
  add_foreign_key "teams_cases", "cases"
  add_foreign_key "teams_cases", "teams"
  add_foreign_key "teams_members", "teams"
  add_foreign_key "teams_members", "users", column: "member_id"
  add_foreign_key "teams_scorers", "scorers"
  add_foreign_key "teams_scorers", "teams"
  add_foreign_key "tries", "cases", name: "tries_ibfk_1"
  add_foreign_key "users", "scorers", column: "default_scorer_id"
end
