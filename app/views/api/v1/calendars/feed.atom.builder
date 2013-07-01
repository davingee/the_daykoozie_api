atom_feed :language => 'en-US' do |feed|
  feed.title @title
  feed.updated @updated
  feed.logo "#{request.protocol + request.host_with_port}/images/logos/logotype-sans-small.png"
  feed.icon "#{request.protocol + request.host_with_port}/images/logos/logotype-sans-small.png"

  @calendars.each do |calendar|
    next if calendar.updated_at.blank?

    feed.entry(calendar, :url =>  "#{request.protocol + request.host_with_port}/calendars/#{calendar.id}") do |entry|
      
      entry.url "#{request.protocol + request.host_with_port}/calendars/#{calendar.id}"
      
      entry.title calendar.title
      entry.content calendar.description, :type => 'html'
      entry.link href: "#{request.protocol + request.host_with_port}#{calendar.image.url(:medium)}", rel:"enclosure", type:"image/jpeg", :height => 150, :width => 300 

      # the strftime is needed to work with Google Reader.
      entry.updated(calendar.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ")) 

      entry.author do |author|
        author.name(calendar.user.name)
      end
    end
  end
end

