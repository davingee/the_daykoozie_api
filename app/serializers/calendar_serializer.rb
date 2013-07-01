class CalendarSerializer < ActiveModel::Serializer
  attributes :description, :image, :name, :private, :title, :user_id
  
end
