class CalendarFollower < ActiveRecord::Base
  attr_accessible :calendar_id, :user_id

  belongs_to :user
  belongs_to :calendar
  
end
