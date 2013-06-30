class ShareSerializer < ActiveModel::Serializer
  attributes :id, :campaign_id, :latitude, :longitude, :visitor_id, :user_id
end
