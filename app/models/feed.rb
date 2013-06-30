class Feed < ActiveRecord::Base
  attr_accessible :calendar_id, :etag, :kind, :last_modified, :published, :url, :user_id
end
