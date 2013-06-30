class UserAuthenticationSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :provider, :uid
end
