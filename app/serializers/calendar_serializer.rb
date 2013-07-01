class CalendarSerializer < ActiveModel::Serializer
  attributes :id, :description, :image, :secret, :title, :user_id
  
  has_many :events 
  
  def include_events?
    object.show_events == true
  end
  
end
