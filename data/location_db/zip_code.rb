class ZipCode < ActiveRecord::Base
  attr_accessible :area_code, :area_name, :city, :country, :country_code, :geocoded, :latitude, :longitude, :name, :state, :state_code, :time_zone
  #NOT USED! USED TO IMPORT PostalCode table

end
