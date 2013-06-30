class User < ActiveRecord::Base
  attr_accessible :avatar, :birthday, :first_name, :gender, :last_name, :latitude, :longitude, :omniauth, :time_zone, :username, :auth_token, :authentication_token, :confirmation_sent_at, :confirmation_token, :confirmed, :confirmed_at, :email, :has_been_geocoded, :image, :ip_address, :locked_at, :password_digest, :password_reset_sent_at, :password_reset_token, :soft_delete, :unlock_token, :password, :password_confirmation

  attr_accessor :provider, :uid, :send_auth_token

  has_secure_password

  has_many :user_roles
  has_many :user_authentications
  has_many :contacts
  has_many :events
  has_many :calendars
  has_many :calendar_followers
  has_many :followings, :through => :calendar_followers, :source => :calendar
  has_many :calendar_roles
  has_many :event_attendees
  # has_many :attendees, :through => :event_attendees, :source => :event
  mount_uploader :image, AvatarUploader
  
  
  # before_create :default_name

  # def default_name
  #   self.name ||= File.basename(image.filename, '.*').titleize if image
  # end
  
  # has_many :reviews, :class_name => :comment, 
  #   :foreign_key => :author_id, :dependent => :destroy
  
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id", :class_name =>  "Relationship", :dependent => :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  
  has_many :user_notifications, :dependent => :destroy

  has_one :user_email_setting

  validates :first_name, :last_name, :presence => true
  delegate :send_friend_followed_calendar?, :send_new_comment?, :to => :user_email_setting

  validates_presence_of :password, :on => :create, :unless => :omniauth_used

  validates_presence_of :first_name, :last_name
  validates :email, :email_format => true
  validates_uniqueness_of :email

  scope :to_show,   where(:soft_delete => false)

  def omniauth_used
    omniauth?
  end

  def name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end

  def is(role)
    (user_roles.map(&:role).include? role.to_sym) ? true : false
  end

  def ensure_authentication_token!
    generate_token(:authentication_token)
    self.save
  end

  before_create { generate_token(:authentication_token) }

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def apply_omniauth(auth)
    # puts "apply_omniauth = #{auth.inspect}"
    if user_authentications.build(:provider => auth["provider"], :uid => auth["uid"]).valid?
      self.omniauth = true
      if auth["provider"] == "facebook"
        facebook_auth(auth)
      elsif auth["provider"] == "google"
        google_auth(auth)
      else
        self.omniauth = false
        return false
      end
      return true
    else
      return false
    end
  end

  def re_apply_omniauth(provider, uid)
    return false unless ["facebook", "google"].include? provider
    user_authentications.build(:provider => provider, :uid => uid).valid? ? true : false
  end

  def facebook_auth(auth)
    self.username           = auth["info"]["nickname"]
    self.email              = auth["info"]["email"]
    self.gender             = auth["extra"]["raw_info"]["gender"]
    self.first_name         = auth["info"]["first_name"]
    self.last_name          = auth["info"]["last_name"]
    # self.time_zone        = ActiveSupport::TimeZone.us_zones[auth.extra.raw_info.timezone].name 
  end

  def google_auth(auth)
    # self.username           = auth["info"]["nickname"]
    # self.email              = auth["info"]["email"]
    # self.gender             = auth["extra"]["raw_info"]["gender"]
    # self.first_name         = auth["info"]["first_name"]
    # self.last_name          = auth["info"]["last_name"]
    # self.time_zone        = ActiveSupport::TimeZone.us_zones[auth.extra.raw_info.timezone].name 
  end
end
