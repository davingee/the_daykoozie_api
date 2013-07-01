class ThePostalCode < ActiveRecord::Base
  # attr_accessible :title, :body

  def migrate_data
    # ThePostalCode.where(:countrycode => "US")
    # Country.all.each do |country|
    #   puts country.name
    #   puts country.id
    #   country.name = country.name.downcase
    #   country.save
    # end

    Location.where(:country_id => 880262049).each do |l|
      l.city = l.city.downcase
      l.region = l.region.downcase
      l.save
    end

    # PostalCode.includes(:city)
    # City.includes(:postal_code).where(:postal_code => {:})
    # a postal_code_regions join table that has lat and lng
    ZipCode.where(:geocoded => true).each do |z|
      ls = Location.where(:country_id => 880262049).find_all_by_postal_code(z.name)
      if ls.count == 1
        l = ls.first
        l.latitude = z.latitude
        l.longitude = z.longitude
        l.time_zone = z.time_zone
        z.geocoded = false
        z.save
      else
        if ls.present?
          puts "has two #{ls.first.city} #{ls.first.region}"
        else
          puts "no record in table #{z.name} #{z.city}"
        end
      end
    end
    
    ThePostalCode.where("admin1code is NOT NULL").find_in_batches do |group|
      group.each do |p|
        country = Country.find_by_alpha2(p.countrycode)
        next if country.blank? or p.admin1code.blank?
        location = country.locations.find_or_initialize_by_postal_code_and_city_and_region(p.postalcode, p.placename.downcase, p.admin1name.downcase)
        unless location.new_record?
          location.region_code = p.admin1code
          location.save!
        end
      end
    end

    # ThePostalCode.update_all(:migrated => false)
    # 
    # Location.destroy_all

    ThePostalCode.where(:migrated => true).find_in_batches do |group|
      group.each do |p|
        country = Country.find_by_alpha2(p.countrycode)
        next if country.blank? or p.admin1name.blank? or p.postalcode.blank? or p.placename.blank?
        location = country.locations.find_or_initialize_by_postal_code_and_city_and_region(p.postalcode, p.placename.downcase, p.admin1name.downcase)
        location.region_code = p.admin1code
        location.latitude = p.latitude
        location.longitude =  p.longitude
        location.save!
        p.migrated = true
        p.save
      end
    end

    # PostalCode.find_in_batches do |group|
    #   group.each do |p|
    #     c = CityPostalCode.find_or_initialize_by_country_id_and_region_and_city_and_postal_code(p.country_id, p.region.name, p.city.name, p.name)
    #     c.region_code = p.region.code
    #     c.latitude = p.latitude
    #     c.longitude = p.longitude
    #     c.save
    #   end
    # end
    # # ("bars.id IS NOT NULL")
    # PostalCode.where("time_zone IS NOT NULL").find_in_batches do |group|
    #   group.each do |p|
    #     c = CityPostalCode.find_or_initialize_by_country_id_and_region_and_city_and_postal_code(p.country_id, p.region.name, p.city.name, p.name)
    #     c.region_code = p.region.code
    #     c.latitude = p.latitude
    #     c.longitude = p.longitude
    #     c.time_zone = p.time_zone
    #     c.save
    #   end
    # end




    # find duplicate postal_code
    # 
    # p = PostalCode.
    #   select("COUNT(name) as total, name").
    #   group(:name).
    #   having("COUNT(name) > 1").
    #   order(:name)
    #   
      # map{|p| {p.name => p.total} }

    # Article.find(:all, :select => 'articles.*, count(posts.id) as post_count',
    #              :joins => 'left outer join posts on posts.article_id = articles.id',
    #              :group => 'articles.id'
    #             )

    # find postal_codes with multiple cities
    # c = City.find(:all, :select => 'cities.*, count(postal_codes) as postal_code_count',
    #              :joins => 'left outer join postal_codes on postal_codes.city_id = cities.id',
    #              :group => 'cities.id'
    #             )

    # ThePostalCode.where(:migrated => false).find_in_batches do |group|
    #   group.each do |p|
    #     country = Country.find_by_alpha2(p.countrycode)
    #     next if country.blank? or p.admin1name.blank?
    #     region = country.regions.find_or_create_by_name(p.admin1name.downcase)
    #     next if p.placename.blank?
    #     city = region.cities.find_or_create_by_name(p.placename.downcase)
    #     next if p.postalcode.blank?
    #     postal_code = city.postal_codes.find_or_initialize_by_name(p.postalcode)
    #     postal_code.country_id = country.id
    #     postal_code.region_id = region.id
    #     postal_code.latitude = p.latitude
    #     postal_code.longitude = p.longitude
    #     postal_code.save
    #     p.migrated = true
    #     p.save
    #   end
    # end


  end

  # def put_city_region_id
  #   PostalCode.includes(:city, :region, :country).where(:region_id => nil).each do |p|
  #     p.region_id = p.city.region_id
  #     p.country_id = p.city.country
  #   end
  # end
      
  #     puts "placename: #{p.placename}"
  #     puts "admin1name: #{p.admin1name}"
  #     puts "admin1code: #{p.admin1code}"
  #     puts "admin2name: #{p.admin2name}"
  #     puts "admin2code: #{p.admin2code}"
  #     puts "admin3name: #{p.admin3name}"
  #     puts "admin3code: #{p.admin3code}"
  #     puts "----------------------------"
  #   end
  # 
  #   ThePostalCode.where(:countrycode => "US").each do |p|
  #     puts "placename: #{p.placename}"
  #     puts "admin1name: #{p.admin1name}"
  #     puts "admin1code: #{p.admin1code}"
  #     puts "admin2name: #{p.admin2name}"
  #     puts "admin2code: #{p.admin2code}"
  #     puts "admin3name: #{p.admin3name}"
  #     puts "admin3code: #{p.admin3code}"
  #     puts "----------------------------"
  #   end
  # 
  # 
  # end
end
