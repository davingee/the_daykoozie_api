class CreateUserAuthentications < ActiveRecord::Migration
  def change
    create_table :user_authentications do |t|
      t.string :uid
      t.string :provider
      t.integer :user_id

      t.timestamps
    end
    add_index :user_authentications, :user_id
    add_index :user_authentications, :provider
    add_index :user_authentications, :uid
  end
end
