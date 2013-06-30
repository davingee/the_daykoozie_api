class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :user_id
      t.integer :calendar_id
      t.integer :event_id
      t.text    :body
      t.boolean :deleted
      t.integer :parent_id
      t.timestamps
    end
    add_index :messages, :parent_id
    add_index :messages, :user_id
    add_index :messages, :calendar_id
    add_index :messages, :event_id
  end
end
