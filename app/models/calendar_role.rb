class CalendarRole < ActiveRecord::Base

  attr_accessible :calendar_id, :role, :user_id

  ROLES = [:owner, :admin, :manager, :follower]
  symbolize :role, :in => ROLES, :scopes => true
  validates :role, :inclusion=> { :in => ROLES }

  belongs_to :calendar
  belongs_to :user
  
  ROLES.each do |role|
    scope :"#{role.to_s.pluralize}", includes(:calendar).where(:role => "#{role}")
  end

  scope :my_calendars, where("role in (?)", ROLES)
end
