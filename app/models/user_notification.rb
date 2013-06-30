class UserNotification < ActiveRecord::Base
  attr_accessible :kind, :notificationable_id, :notificationable_type, :state, :user_id

  belongs_to :user
  belongs_to :calendar

  delegate :send_friend_followed_calendar?, :send_new_comment?, :to => :user

  STATES = [:active, :viewed, :no_record]
  symbolize :state, :in => STATES, :scopes => true
  validates :state, :inclusion=> { :in => STATES }

  KINDS = %W(friend_followed_calendar new_comment) 
  validates :kind, :inclusion=> { :in => KINDS }


  # send user and calendar to here
  after_create :send_email
  def send_email
    if friend_followed_calendar? and send_friend_followed_calendar?
      # Emailer.friend_followed_calendar(notificationable_id, user_id).deliver
    elsif new_comment? and send_new_comment?
      # Emailer.new_comment(notificationable_id, user_id).deliver
    end
  end

  def name
    if friend_followed_calendar? 
      "Your friend has started following a calendar."
    elsif new_comment?
      "You have a new comment."
    end
  end

  # Is there a better way - calendar_path is not accessable by the model??
  include Rails.application.routes.url_helpers

  def link
    begin
      if friend_followed_calendar? 
        calendar_path(Calendar.find(notificationable_id))
      elsif new_comment?
        calendar_path(Calendar.find(notificationable_id))
      end
    rescue ActiveRecord::RecordNotFound
      self.state = :no_record
      self.save
      "#"
    end
  end

  def active?
    state.to_s == "active"
  end

  def viewed?
    state.to_s == "viewed"
  end

  def new_comment?
    kind == "new_comment"
  end

  def friend_followed_calendar?
    kind == "friend_followed_calendar"
  end
end
