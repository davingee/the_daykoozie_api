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

ActiveRecord::Schema.define(:version => 20130621000353) do

  create_table "calendar_followers", :force => true do |t|
    t.integer  "calendar_id"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "calendar_followers", ["calendar_id"], :name => "index_calendar_followers_on_calendar_id"
  add_index "calendar_followers", ["user_id"], :name => "index_calendar_followers_on_user_id"

  create_table "calendar_roles", :force => true do |t|
    t.integer  "calendar_id"
    t.integer  "user_id"
    t.string   "role"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "calendar_roles", ["calendar_id"], :name => "index_calendar_roles_on_calendar_id"
  add_index "calendar_roles", ["user_id"], :name => "index_calendar_roles_on_user_id"

  create_table "calendars", :force => true do |t|
    t.string   "title"
    t.string   "name"
    t.string   "description"
    t.boolean  "private",     :default => false
    t.integer  "user_id"
    t.string   "image"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "calendars", ["user_id"], :name => "index_calendars_on_user_id"

  create_table "contacts", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.text     "body"
    t.string   "subject"
    t.integer  "user_id"
    t.string   "ip_address"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "contacts", ["user_id"], :name => "index_contacts_on_user_id"

  create_table "event_attendees", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "event_attendees", ["event_id"], :name => "index_event_attendees_on_event_id"
  add_index "event_attendees", ["user_id"], :name => "index_event_attendees_on_user_id"

  create_table "events", :force => true do |t|
    t.string   "title"
    t.string   "feed_url"
    t.string   "etag"
    t.string   "author"
    t.string   "summary"
    t.text     "content"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "calendar_id"
    t.integer  "user_id"
    t.string   "image"
    t.datetime "last_modified"
    t.datetime "published"
    t.string   "url"
    t.boolean  "all_day",       :default => false
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "events", ["calendar_id"], :name => "index_events_on_calendar_id"
  add_index "events", ["user_id"], :name => "index_events_on_user_id"

  create_table "feeds", :force => true do |t|
    t.string   "url"
    t.string   "etag"
    t.datetime "last_modified"
    t.datetime "published"
    t.integer  "calendar_id"
    t.integer  "user_id"
    t.string   "kind"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "feeds", ["calendar_id"], :name => "index_feeds_on_calendar_id"
  add_index "feeds", ["user_id"], :name => "index_feeds_on_user_id"

  create_table "message_hierarchies", :id => false, :force => true do |t|
    t.integer "ancestor_id",   :null => false
    t.integer "descendant_id", :null => false
    t.integer "generations",   :null => false
  end

  add_index "message_hierarchies", ["ancestor_id", "descendant_id"], :name => "index_message_hierarchies_on_ancestor_id_and_descendant_id", :unique => true
  add_index "message_hierarchies", ["descendant_id"], :name => "index_message_hierarchies_on_descendant_id"

  create_table "messages", :force => true do |t|
    t.integer  "user_id"
    t.integer  "calendar_id"
    t.integer  "event_id"
    t.text     "body"
    t.boolean  "deleted"
    t.integer  "parent_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "messages", ["calendar_id"], :name => "index_messages_on_calendar_id"
  add_index "messages", ["event_id"], :name => "index_messages_on_event_id"
  add_index "messages", ["parent_id"], :name => "index_messages_on_parent_id"
  add_index "messages", ["user_id"], :name => "index_messages_on_user_id"

  create_table "relationships", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "relationships", ["followed_id"], :name => "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], :name => "index_relationships_on_follower_id_and_followed_id", :unique => true
  add_index "relationships", ["follower_id"], :name => "index_relationships_on_follower_id"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "user_authentications", :force => true do |t|
    t.string   "uid"
    t.string   "provider"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_authentications", ["provider"], :name => "index_user_authentications_on_provider"
  add_index "user_authentications", ["uid"], :name => "index_user_authentications_on_uid"
  add_index "user_authentications", ["user_id"], :name => "index_user_authentications_on_user_id"

  create_table "user_email_settings", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "send_friend_followed_calendar", :default => true
    t.boolean  "send_new_comment",              :default => true
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
  end

  add_index "user_email_settings", ["user_id"], :name => "index_user_email_settings_on_user_id"

  create_table "user_notifications", :force => true do |t|
    t.integer  "user_id"
    t.integer  "notificationable_id"
    t.string   "notificationable_type"
    t.string   "kind"
    t.string   "state",                 :default => "active"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  add_index "user_notifications", ["notificationable_id"], :name => "index_user_notifications_on_notificationable_id"
  add_index "user_notifications", ["notificationable_type"], :name => "index_user_notifications_on_notificationable_type"
  add_index "user_notifications", ["user_id"], :name => "index_user_notifications_on_user_id"

  create_table "user_roles", :force => true do |t|
    t.integer  "user_id"
    t.string   "role"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_roles", ["user_id"], :name => "index_user_roles_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.string   "time_zone"
    t.string   "image"
    t.date     "birthday"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "omniauth",               :default => false
    t.boolean  "has_been_geocoded",      :default => false
    t.boolean  "soft_delete",            :default => false
    t.string   "email"
    t.string   "password_digest"
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "authentication_token"
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "ip_address"
    t.boolean  "confirmed",              :default => false
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["password_reset_token"], :name => "index_users_on_password_reset_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

end
