class UserNotification < ActiveRecord::Base
  attr_accessible :kind, :notificationable_id, :notificationable_type, :state, :user_id
end
