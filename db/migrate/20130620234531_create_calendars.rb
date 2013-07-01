class CreateCalendars < ActiveRecord::Migration
  def change
    create_table :calendars do |t|
      t.string :title
      t.string :description
      t.boolean :secret, :default => false
      t.integer :user_id
      t.string :image

      t.timestamps
    end
    add_index :calendars, :user_id
  end
end
