class Feed < ActiveRecord::Base
  attr_accessible :calendar_id, :etag, :kind, :last_modified, :published, :url, :user_id

  # attr_accessible :calendar_id, :category_id, :name, :url, :user_id
  # 
  # 
  # def parse
  #   
  #   # https://github.com/icalendar/icalendar
  #   # http://www.hokiesports.com/calendar/main.php?view=subscribe
  # 
  #   sports_url = "http://www.hokiesports.com/calendar/export/export.php?calendar=default&format=ical&timebegin=upcoming"
  #   academic_url = "http://www.calendar.vt.edu/main.php?view=subscribe"
  #   
  #   # Parser returns an array of calendars because a single file
  #   # can have multiple calendars.
  #   cal_file = File.open("#{Rails.root}/public/export.ics")
  #   # Some calendars contain non-standard parameters (e.g. Apple iCloud
  #   # calendars). You can pass in a `strict` value when creating a new parser.
  #   # unstrict_parser = Icalendar::Parser.new(cal_file, false)
  #   # cal = unstrict_parser.parse()
  #   calendars = Icalendar.parse(cal_file)
  #   # Now you can access the cal object in just the same way I created it
  #   calendars.each do |calendar|
  #     calendar.events.each do |event|
  #       puts "start date-time: #{event.dtstart}"
  #       puts "end date-time: #{event.dtend}"
  #       puts "summary: #{event.summary}"
  #       puts "description: #{event.description}"
  #       puts "category: #{event.categories}"
  #       puts "location: #{event.location}"
  #     end
  #   end
  # 
  # 
  #   => #<Icalendar::Event:0x007fdc246f07b8 @name="VEVENT", @components={}, @properties={"sequence"=>0, "dtstamp"=>Thu, 04 Apr 2013 04:00:00 +0000, "uid"=>"1365103645000@http://www.hokiesports.com/calendar/", "categories"=>["Track & Field"], "dtstart"=>Thu, 04 Apr 2013, "dtend"=>Fri, 05 Apr 2013, "summary"=>"Track & Field: at Colonial Relays", "description"=>"Colonial Relays\n\n", "location"=>"Williamsburg, Va."}> 
  # 
  #   
  #   # fetching a single feed
  #   feed = Feedzirra::Feed.fetch_and_parse("http://feeds.feedburner.com/PaulDixExplainsNothing")
  # 
  #   # feed and entries accessors
  #   feed.title          # => "Paul Dix Explains Nothing"
  #   feed.url            # => "http://www.pauldix.net"
  #   feed.feed_url       # => "http://feeds.feedburner.com/PaulDixExplainsNothing"
  #   feed.etag           # => "GunxqnEP4NeYhrqq9TyVKTuDnh0"
  #   feed.last_modified  # => Sat Jan 31 17:58:16 -0500 2009 # it's a Time object
  # 
  #   entry = feed.entries.first
  #   entry.title      # => "Ruby Http Client Library Performance"
  #   entry.url        # => "http://www.pauldix.net/2009/01/ruby-http-client-library-performance.html"
  #   entry.author     # => "Paul Dix"
  #   entry.summary    # => "..."
  #   entry.content    # => "..."
  #   entry.published  # => Thu Jan 29 17:00:19 UTC 2009 # it's a Time object
  #   entry.categories # => ["...", "..."]
  # 
  #   # sanitizing an entry's content
  #   entry.title.sanitize   # => returns the title with harmful stuff escaped
  #   entry.author.sanitize  # => returns the author with harmful stuff escaped
  #   entry.content.sanitize # => returns the content with harmful stuff escaped
  #   entry.content.sanitize! # => returns content with harmful stuff escaped and replaces original (also exists for author and title)
  #   entry.sanitize!         # => sanitizes the entry's title, author, and content in place (as in, it changes the value to clean versions)
  #   feed.sanitize_entries!  # => sanitizes all entries in place
  # 
  #   # updating a single feed
  #   updated_feed = Feedzirra::Feed.update(feed)
  # 
  #   # an updated feed has the following extra accessors
  #   updated_feed.updated?     # returns true if any of the feed attributes have been modified. will return false if only new entries
  #   updated_feed.new_entries  # a collection of the entry objects that are newer than the latest in the feed before update
  # 
  # 
  # 
  # 
  # 
  #   feed_urls = 
  #   %w{http://www.hokiesports.com/vtbaseball.xml 
  #     http://www.hokiesports.com/vtmbasketball.xml 
  #     http://www.hokiesports.com/vtwbasketball.xml 
  #     http://www.hokiesports.com/vtcc.xml
  #     http://www.hokiesports.com/vtfootball.xml
  #     http://www.hokiesports.com/vtgolf.xml
  #     http://www.hokiesports.com/vtlax.xml
  #     http://www.hokiesports.com/vtmsoccer.xml
  #     http://www.hokiesports.com/vtwsoccer.xml
  #     http://www.hokiesports.com/vtsoftball.xml
  #     http://www.hokiesports.com/vtswimming.xml
  #     http://www.hokiesports.com/vtmtennis.xml
  #     http://www.hokiesports.com/vtwtennis.xml
  #     http://www.hokiesports.com/vttrack.xml
  #     http://www.hokiesports.com/vtvolleyball.xml
  #     http://www.hokiesports.com/vtwrestling.xml
  #   }
  # 
  #   feed_url = "http://www.hokiesports.com/vtbaseball.xml"
  #   # fetching multiple feeds
  #   feeds = Feedzirra::Feed.fetch_and_parse(feeds_urls)
  #   feed = Feedzirra::Feed.fetch_and_parse(feed_url)
  #   
  #   feed.entries.first.
  #   entry.categories.each_do
  #   sub_category = Category.find_or_create_by_name()
  #   category = Category.find_or_create_by_name("Sports")
  #   # feeds is now a hash with the feed_urls as keys and the parsed feed objects as values. If an error was thrown
  #   # there will be a Fixnum of the http response code instead of a feed object
  # 
  #   # updating multiple feeds. it expects a collection of feed objects
  #   updated_feeds = Feedzirra::Feed.update(feeds.values)
  # 
  #   # defining custom behavior on failure or success. note that a return status of 304 (not updated) will call the on_success handler
  #   feed = Feedzirra::Feed.fetch_and_parse("http://feeds.feedburner.com/PaulDixExplainsNothing",
  #     :on_success => lambda {|feed| puts feed.title },
  #     :on_failure => lambda {|url, response_code, response_header, response_body| puts response_body })
  #   # if a collection was passed into fetch_and_parse, the handlers will be called for each one
  # 
  #   # the behavior for the handlers when using Feedzirra::Feed.update is slightly different. The feed passed into on_success will be
  #   # the updated feed with the standard updated accessors. on failure it will be the original feed object passed into update
  # 
  #   # You can add custom parsing to the feed entry classes. Say you want the wfw:comments fields in an entry
  #   Feedzirra::Feed.add_common_feed_entry_element("wfw:commentRss", :as => :comment_rss)
  #   # The arguments are the same as the SAXMachine arguments for the element method. For more example usage look at the RSSEntry and
  #   # AtomEntry classes. Now you can access those in an atom feed:
  #   Feedzirra::Feed.parse(some_atom_xml).entries.first.comment_rss_ # => wfw:commentRss is now parsed!
  # 
  #   # You can also access http basic auth feeds. Unfortunately, you can't get to these inside of a bulk get of a bunch of feeds.
  #   # You'll have to do it on its own like so:
  #   Feedzirra::Feed.fetch_and_parse(some_url, :http_authentication => ["myusername", "mypassword"])
  # 
  #   # Defining custom parsers
  #   # TODO: the functionality is here, just write some good examples that show how to do this
  # end
end
