class CreateEventAttendees < ActiveRecord::Migration
  def change
    create_table :event_attendees do |t|
      t.integer :user_id
      t.integer :event_id

      t.timestamps
    end
    add_index :event_attendees, :user_id
    add_index :event_attendees, :event_id
  end
end
