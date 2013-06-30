class UserAuthentication < ActiveRecord::Base

  attr_accessible :provider, :uid, :user_id

  belongs_to :user
  
  validates_presence_of :uid, :provider, :on => :create
  
end
