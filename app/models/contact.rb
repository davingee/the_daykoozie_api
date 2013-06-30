class Contact < ActiveRecord::Base

  attr_accessible :body, :email, :ip_address, :name, :subject, :user_id
  belongs_to :user

  validates :email, :email_format => true
  validates :name, :email, :body, :subject, :presence => true

  def user?
    user.present?
  end

end
