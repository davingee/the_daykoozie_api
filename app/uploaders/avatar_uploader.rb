# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :file

  def store_dir
    "system/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process convert: 'png', :resize_to_fit => [1024, 1024]

  version :medium do
    process resize_to_fit: [300, 300]
    process convert: 'png'
  end

  version :thumb do
    process resize_to_fit: [100, 100]
    process convert: 'png'
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
  
  def default_url
    if model.omniauth?
      "#{$request.protocol}graph.facebook.com/#{model.user_authentications.find_by_provider("facebook").uid}/picture?type=square"
    else
      "/assets/logos/blue-icon-white-k-small.png"
    end
  end

end
