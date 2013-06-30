class UserRole < ActiveRecord::Base
  attr_accessible :role, :user_id
  
  ROLES = [:admin, :user]
  symbolize :role, :in => ROLES, :scopes => true
  validates :role, :inclusion=> { :in => ROLES }
  
  belongs_to :user
end
