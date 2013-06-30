class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :url
      t.string :etag
      t.datetime :last_modified
      t.datetime :published
      t.integer :calendar_id
      t.integer :user_id
      t.string :kind

      t.timestamps
    end
    add_index :feeds, :user_id
    add_index :feeds, :calendar_id
  end
end
