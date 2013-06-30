class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :first_name, :last_name, :gender, :latitude, :longitude, :time_zone, :image, :birthday, :omniauth, :has_been_geocoded, :soft_delete, :email, :password_digest, :auth_token, :password_reset_token, :password_reset_sent_at, :authentication_token, :unlock_token, :locked_at, :confirmation_token, :confirmed_at, :confirmation_sent_at, :ip_address, :confirmed, :provider, :uid
  
  def provider
    
  end
  
  def uid
  
  end
  
end
