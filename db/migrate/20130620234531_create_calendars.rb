class CreateCalendars < ActiveRecord::Migration
  def change
    create_table :calendars do |t|
      t.string :title
      t.string :name
      t.string :description
      t.boolean :private, :default => false
      t.integer :user_id
      t.string :image

      t.timestamps
    end
    add_index :calendars, :user_id
  end
end
