class CreateUserNotifications < ActiveRecord::Migration
  def change
    create_table :user_notifications do |t|
      t.integer :user_id
      t.integer :notificationable_id
      t.string :notificationable_type
      t.string :kind
      t.string :state, :default => :active

      t.timestamps
    end
    add_index :user_notifications, :user_id
    add_index :user_notifications, :notificationable_id
    add_index :user_notifications, :notificationable_type
  end
end
