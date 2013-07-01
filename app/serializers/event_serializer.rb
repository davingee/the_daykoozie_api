class EventSerializer < ActiveModel::Serializer
  attributes :all_day, :author, :calendar_id, :content, :end_time, :etag, :feed_url, :image, :last_modified, :published, :start_time, :summary, :title, :url, :user_id
  
end
