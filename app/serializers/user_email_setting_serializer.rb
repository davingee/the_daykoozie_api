class UserEmailSettingSerializer < ActiveModel::Serializer
  attributes :send_friend_followed_calendar, :send_new_comment, :user_id
  
end
