class CreateUserEmailSettings < ActiveRecord::Migration
  def change
    create_table :user_email_settings do |t|
      t.integer :user_id
      t.boolean :send_friend_followed_calendar, :default => true
      t.boolean :send_new_comment, :default => true

      t.timestamps
    end
    add_index :user_email_settings, :user_id
  end
end
