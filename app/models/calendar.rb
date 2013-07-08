class Calendar < ActiveRecord::Base
  attr_accessible :category_id, :description, :image, :secret, :title, :user_id

  attr_accessor :tag_categories, :show_events

  belongs_to :user
  has_many :events, :dependent => :destroy
  
  has_many :calendar_roles
  has_many :calendar_followers
  
  mount_uploader :image, ImageUploader

  # scope :followers, lambda{ |name| where(name: name) unless name.nil? }

  # scope :mine, includes(:calendar_roles).where("calendar_roles.role in (?)", ["follower", "admin", "owner"])
  acts_as_taggable
  acts_as_taggable_on :categories
  
  validates :title, :description, :presence => true
  
  
  scope :not_secret,   where(:secret => false)
  
  # def followers
  #   puts self
  #   Calendar.where(:calendar_id => id).includes(:calendar_roles).where(:calendar_roles => {:role => "follower"})
  # end

  def self.search(search)
    if search
      where('name ILIKE ?', "%#{search}%")
    else
      scoped
    end
  end

  def calendar_role?(user, roles)
    calendar_roles.where(:user_id => user.id).any? { |calendar_role| roles.include? calendar_role.role }
  end
  
  def role_is(role, user_id)
    calendar_roles.find_by_by_user_id(user_id).map(&:role).include? role
  end
  
  after_create :create_owner_role
  def create_owner_role
    self.calendar_roles.create!(:user_id => user.id, :role => :owner)
  end
end
