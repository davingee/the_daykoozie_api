class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string    :name
      t.string    :email
      t.text      :body
      t.string    :subject
      t.integer   :user_id
      t.string    :ip_address
      t.timestamps
    end
    add_index :contacts, :user_id
  end
end
