class Message < ActiveRecord::Base
  attr_accessible :ancestry, :body, :calendar_id, :deleted, :event_id, :user_id
end
