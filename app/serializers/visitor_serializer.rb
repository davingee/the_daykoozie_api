class VisitorSerializer < ActiveModel::Serializer
  attributes :id, :has_been_geocoded, :latitude, :longitude, :ip_address
end
