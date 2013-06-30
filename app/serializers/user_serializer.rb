class UserSerializer < ActiveModel::Serializer
  # attributes :id, :username, :first_name, :last_name, :gender, :latitude, :longitude, :time_zone, :image, :birthday, :omniauth, :has_been_geocoded, :soft_delete, :email, :password_digest, :auth_token, :password_reset_token, :password_reset_sent_at, :authentication_token, :unlock_token, :locked_at, :confirmation_token, :confirmed_at, :confirmation_sent_at, :ip_address, :confirmed, :provider, :uid
  attributes :id, :first_name, :last_name, :gender, :time_zone, :image

  def attributes
    hash = super

    if current_user and current_user.id == object.id
      hash["email"] = object.email
      hash["omniauth"] = object.omniauth
      hash["birthday"] = object.birthday
      hash["soft_delete"] = object.soft_delete
      hash["confirmed"] = object.confirmed
      hash["authentication_token"] = object.authentication_token
    end

    if object.send_auth_token == true
      hash["authentication_token"] = object.authentication_token
    end

    unless object.provider.blank?
      hash["provider"] = object.provider
      hash["uid"] = object.uid
    end

    if object.has_been_geocoded?
      hash["latitude"] = object.latitude
      hash["longitude"] = object.longitude
    end

    hash

  end
end
