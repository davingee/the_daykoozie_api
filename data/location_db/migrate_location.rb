class MigrateLocation

  def zip_code_to_city_region_etc
    ZipCode.all.each do |zip_code|
      country = Country.where("LOWER(name)=LOWER('#{zip_code.country}')").first
      region = country.regions.find_or_create_by_name_and_code(zip_code.state.downcase, zip_code.state_code.upcase) unless country.name.blank? or zip_code.state.blank? or zip_code.state_code.blank?
      city = region.cities.find_or_create_by_name_and_country_id(zip_code.city.downcase, country.id) unless region.name.blank? or zip_code.city.blank?
      postal_code = city.postal_codes.find_or_create_by_name_and_city_id_and_region_id_and_country_id(zip_code.name, city.id, region.id, country.id) unless city.name.blank? or zip_code.name.blank?
      postal_code.update_attributes(:geocoded => zip_code.geocoded, :longitude => zip_code.longitude, :latitude => zip_code.latitude, :time_zone => zip_code.time_zone) unless postal_code.name.blank?
    end
  end

end
