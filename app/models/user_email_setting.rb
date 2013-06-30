class UserEmailSetting < ActiveRecord::Base
  attr_accessible :send_friend_followed_calendar, :send_new_comment, :user_id
end
