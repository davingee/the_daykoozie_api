class UserAuthentication < ActiveRecord::Base
  attr_accessible :provider, :uid, :user_id
end