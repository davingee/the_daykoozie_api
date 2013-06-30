class VisitSerializer < ActiveModel::Serializer
  attributes :id, :ip_address, :user_agent, :referer, :visitor_id, :user_id
end
