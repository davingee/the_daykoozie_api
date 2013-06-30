class Contact < ActiveRecord::Base
  attr_accessible :content, :email, :name, :subject, :user_id
end
