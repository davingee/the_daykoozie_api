class UserNotificationSerializer < ActiveModel::Serializer

  attributes :kind, :notificationable_id, :notificationable_type, :state, :user_id

end
