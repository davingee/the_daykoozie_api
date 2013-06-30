class CreateCalendarFollowers < ActiveRecord::Migration
  def change
    create_table :calendar_followers do |t|
      t.integer :calendar_id
      t.integer :user_id

      t.timestamps
    end
    add_index :calendar_followers, :user_id
    add_index :calendar_followers, :calendar_id
  end
end
