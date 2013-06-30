class ContactSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :subject, :body, :user_id, :ip_address
end
