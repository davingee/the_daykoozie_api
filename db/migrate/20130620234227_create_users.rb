class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.string :time_zone
      t.string :avatar
      t.date :birthday
      t.float :latitude
      t.float :longitude


      t.boolean :omniauth, :default => false
      t.boolean :has_been_geocoded, :default => false
      t.boolean :soft_delete, :default => false
      t.string :email
      t.string :password_digest
      t.string :auth_token
      t.string :password_reset_token
      t.datetime :password_reset_sent_at
      t.string :authentication_token
      t.string :unlock_token
      t.datetime :locked_at
      t.string :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string :ip_address
      t.boolean :confirmed, :default => false

      t.timestamps
    end
    add_index :users, :password_reset_token,  :unique => true
    add_index :users, :confirmation_token,    :unique => true
    add_index :users, :unlock_token,          :unique => true
    add_index :users, :email,                 :unique => true
    add_index :users, :authentication_token,  :unique => true
  end
end
