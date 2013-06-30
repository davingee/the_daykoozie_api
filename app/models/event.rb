class Event < ActiveRecord::Base
  attr_accessible :all_day, :author, :calendar_id, :content, :end_time, :etag, :feed_url, :image, :last_modified, :published, :start_time, :summary, :title, :url, :user_id

  attr_accessor :user_calendar_role
  belongs_to :user
  belongs_to :calendar
  acts_as_taggable
  acts_as_taggable_on :categories

  has_many :event_attendees
  # has_many :followers, :through => :calendar_followers
  has_many :attendees, :through => :event_attendees, :source => :user


  # scope :between, lambda {|start_time, end_time|
  #   {:conditions => ["? < starts_at < ?", Event.format_date(start_time), Event.format_date(end_time)] }
  # }
  # {:conditions => [
  #   "starts_at > ? and starts_at < ?",
  #   Event.format_date(start_time), Event.format_date(end_time)
  # ] }
  # def self.between(start_time, end_time)
  #   where('starts_at > :lo and starts_at < :up',
  #     :lo => Event.format_date(start_time),
  #     :up => Event.format_date(end_time)
  #   )
  # end

  mount_uploader :image, ImageUploader

  # def as_json(opts = {})
  #   # super(:only => [:id, :name])
  #   if all_day?
  #     { 
  #       :url => url, 
  #       :allDay => true,
  #       :id => id, 
  #       :title => title, 
  #       :content => content,
  #       :image => image,
  #       :user_calendar_role => opts[:user_calendar_role],
  #       :calendar_id => calendar_id,
  #       :start => start_time.strftime('%Y-%m-%dT%H:%M'), 
  #       :end => end_time.strftime('%Y-%m-%dT%H:%M')
  #     }
  #   else
  #     {
  #       :url => url, 
  #       :allDay => false, 
  #       :id => id, 
  #       :title => title,
  #       :content => content,
  #       :image => image,
  #       :user_calendar_role => opts[:user_calendar_role],
  #       :calendar_id => calendar_id,
  #       :start => start_time.strftime('%Y-%m-%dT%H:%M'), 
  #       :end => end_time.strftime('%Y-%m-%dT%H:%M')
  #     }
  #   end
  # end
end
