class CreateCalendarRoles < ActiveRecord::Migration
  def change
    create_table :calendar_roles do |t|
      t.integer :calendar_id
      t.integer :user_id
      t.string :role

      t.timestamps
    end
    add_index :calendar_roles, :user_id
    add_index :calendar_roles, :calendar_id
  end
end
