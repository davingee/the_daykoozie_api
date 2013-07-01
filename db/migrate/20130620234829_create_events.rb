class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.string :feed_url
      t.string :etag
      t.string :author
      t.string :summary
      t.text :content
      t.datetime :start_time
      t.datetime :end_time
      t.integer :calendar_id
      t.integer :user_id
      t.string :image
      t.datetime :last_modified
      t.datetime :published
      t.string :url
      t.boolean :all_day, :default => false
      t.float :latitude
      t.float :longitude
      t.boolean :has_been_geocoded
      t.timestamps
    end
    add_index :events, :calendar_id
    add_index :events, :user_id
  end
end
