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

ActiveRecord::Schema.define(:version => 20120319090038) do

  create_table "ad_stats", :force => true do |t|
    t.integer  "ad_id"
    t.integer  "user_id"
    t.integer  "views"
    t.integer  "clicks"
    t.integer  "closes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ad_stats", ["ad_id", "user_id"], :name => "index_ad_stats_on_ad_id_and_user_id", :unique => true
  add_index "ad_stats", ["ad_id"], :name => "index_ad_stats_on_ad_id"
  add_index "ad_stats", ["user_id"], :name => "index_ad_stats_on_user_id"

  create_table "ads", :force => true do |t|
    t.integer  "company_id"
    t.integer  "limit"
    t.integer  "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.text     "description"
    t.decimal  "cost_per_impression",  :precision => 10, :scale => 0
    t.decimal  "cost_per_click",       :precision => 10, :scale => 0
    t.decimal  "cost_per_purchase",    :precision => 10, :scale => 0
    t.integer  "love_hate"
    t.integer  "relief_fear"
    t.integer  "excite_bore"
    t.integer  "happy_sad"
    t.integer  "funny_serious"
    t.integer  "sexy_disgust"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.text     "meta_data"
    t.integer  "distance",                                            :default => 0
  end

  add_index "ads", ["company_id"], :name => "index_ads_on_company_id"
  add_index "ads", ["distance"], :name => "index_ads_on_distance"

  create_table "attachments", :force => true do |t|
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  create_table "companies", :force => true do |t|
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
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "paypal_email"
  end

  add_index "companies", ["email"], :name => "index_companies_on_email", :unique => true
  add_index "companies", ["name"], :name => "index_companies_on_name", :unique => true
  add_index "companies", ["reset_password_token"], :name => "index_companies_on_reset_password_token", :unique => true

  create_table "coupon_stats", :force => true do |t|
    t.integer  "coupon_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "game_id"
    t.boolean  "click_through", :default => false
    t.boolean  "impression",    :default => false
  end

  add_index "coupon_stats", ["coupon_id", "user_id"], :name => "index_coupon_stats_on_coupon_id_and_user_id", :unique => true
  add_index "coupon_stats", ["coupon_id"], :name => "index_coupon_stats_on_coupon_id"
  add_index "coupon_stats", ["user_id"], :name => "index_coupon_stats_on_user_id"

  create_table "coupons", :force => true do |t|
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.text     "description"
    t.integer  "limit"
    t.integer  "redeemed",                                           :default => 0
    t.integer  "ext_coupon_id"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.text     "meta_data"
    t.decimal  "cost_per_redeem",      :precision => 8, :scale => 2, :default => 0.0
    t.integer  "displayed",                                          :default => 0
    t.integer  "click_through",                                      :default => 0
  end

  add_index "coupons", ["company_id", "ext_coupon_id"], :name => "index_coupons_on_company_id_and_ext_coupon_id", :unique => true
  add_index "coupons", ["company_id"], :name => "index_coupons_on_company_id"

  create_table "game_earnings", :force => true do |t|
    t.integer  "game_id"
    t.integer  "coupon_id"
    t.decimal  "earnings",    :precision => 9, :scale => 2, :default => 0.0
    t.decimal  "coupon_cost", :precision => 9, :scale => 2, :default => 0.0
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "game_stats", :force => true do |t|
    t.integer  "game_id"
    t.integer  "user_id"
    t.integer  "plays"
    t.decimal  "duration_average", :precision => 10, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "game_stats", ["game_id", "user_id"], :name => "index_game_stats_on_game_id_and_user_id", :unique => true
  add_index "game_stats", ["game_id"], :name => "index_game_stats_on_game_id"
  add_index "game_stats", ["user_id"], :name => "index_game_stats_on_user_id"

  create_table "games", :force => true do |t|
    t.integer  "publisher_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "meta_data"
    t.string   "name"
    t.string   "token"
    t.integer  "impressions",                                :default => 0
    t.decimal  "earnings",     :precision => 8, :scale => 2, :default => 0.0
  end

  add_index "games", ["publisher_id"], :name => "index_games_on_publisher_id"

  create_table "invoices", :force => true do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.integer  "shipping_address_id"
    t.string   "credit_card_token"
    t.decimal  "price",               :precision => 8, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "buyer_ip"
    t.string   "email"
    t.boolean  "dispute",                                           :default => false
    t.boolean  "paid",                                              :default => false
    t.integer  "stripe_customer_id"
  end

  create_table "payments", :force => true do |t|
    t.integer  "user_id"
    t.string   "method"
    t.string   "info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pics", :force => true do |t|
    t.text     "content"
    t.text     "meta_data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "product"
    t.integer  "company_id"
    t.integer  "cost_per_redeem"
    t.integer  "limit"
    t.integer  "redeemed"
    t.string   "picture_link_file_name"
    t.string   "picture_link_content_type"
    t.integer  "picture_link_file_size"
    t.datetime "picture_link_updated_at"
  end

  create_table "pictures", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "pic_file_name"
    t.string   "pic_content_type"
    t.integer  "pic_file_size"
    t.datetime "pic_updated_at"
  end

  create_table "previews", :force => true do |t|
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
  end

  create_table "product_stats", :force => true do |t|
    t.boolean  "impression",    :default => false
    t.boolean  "purchase",      :default => false
    t.integer  "product_id"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ip"
    t.boolean  "click_through", :default => false
  end

  create_table "products", :force => true do |t|
    t.integer  "company_id"
    t.integer  "ext_product_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.text     "meta_data"
    t.decimal  "price",                :precision => 8, :scale => 2, :default => 0.0
    t.integer  "purchased",                                          :default => 0
    t.integer  "displayed",                                          :default => 0
    t.integer  "click_through",                                      :default => 0
    t.string   "product_type"
    t.string   "link"
    t.string   "encrypted_link"
  end

  add_index "products", ["company_id", "ext_product_id"], :name => "index_products_on_company_id_and_ext_product_id", :unique => true
  add_index "products", ["company_id", "name"], :name => "index_products_on_company_id_and_name"
  add_index "products", ["company_id"], :name => "index_products_on_company_id"
  add_index "products", ["ext_product_id"], :name => "index_products_on_ext_product_id"
  add_index "products", ["name"], :name => "index_products_on_name"

  create_table "publishers", :force => true do |t|
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
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
  end

  add_index "publishers", ["email"], :name => "index_publishers_on_email", :unique => true
  add_index "publishers", ["name"], :name => "index_publishers_on_name", :unique => true
  add_index "publishers", ["reset_password_token"], :name => "index_publishers_on_reset_password_token", :unique => true

  create_table "shipping_addresses", :force => true do |t|
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.integer  "zip"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "default",    :default => false
  end

  create_table "states", :force => true do |t|
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tmp_users", :force => true do |t|
    t.string   "email"
    t.integer  "coupon_id"
    t.integer  "game_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "types", :force => true do |t|
    t.string   "name"
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
    t.string   "name"
    t.string   "token"
    t.string   "credit_card_token"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
