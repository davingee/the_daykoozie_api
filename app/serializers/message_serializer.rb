class MessageSerializer < ActiveModel::Serializer
  attributes :ancestry, :body, :calendar_id, :deleted, :event_id, :user_id
  
end
