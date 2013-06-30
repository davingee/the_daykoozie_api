class UrlFormatValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    unless value =~ URI::ABS_URI
      object.errors[attribute] << (options[:message] || "is not formatted properly") 
    end
  end
end

  
  