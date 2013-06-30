atom_feed :language => 'en-US' do |feed|
  feed.title @title
  feed.updated @updated
  # feed.logo "#{base_url}/assets/rails.png"
  feed.icon "#{base_url}/assets/rails.png"
#  hmmm, still doesn't seem to be working, its atom very specific about having the images in a 2:1 ratio? and if they aren't in that format they dont get displayed? – dodgerogers747 Sep 10 '12 at 20:38


  @calendars.each do |calendar|
    next if calendar.updated_at.blank?

    feed.entry( calendar ) do |entry|
      entry.url calendar_url(calendar)
      entry.title calendar.name
      entry.content calendar.description, :type => 'html'
      # entry.link href: "#{base_url}#{campaign.image.url(:medium)}", rel:"enclosure", type:"image/jpeg", :height => 150, :width => 300 

      # the strftime is needed to work with Google Reader.
      entry.updated(calendar.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ")) 

      entry.author do |author|
        author.name(calendar.user.name)
      end
    end
  end
end
