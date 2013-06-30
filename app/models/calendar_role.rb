class CalendarRole < ActiveRecord::Base
  attr_accessible :calendar_id, :role, :user_id
end
