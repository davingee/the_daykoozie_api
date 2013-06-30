Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_APP_ID'] || APP_CONFIG[:facebook_key], ENV['FACEBOOK_APP_SECRET'] || APP_CONFIG[:facebook_secret]
  # provider :linked_in, 'CONSUMER_KEY', 'CONSUMER_SECRET'
end


# config.omniauth :facebook, ENV['FACEBOOK_APP_ID'] || APP_CONFIG[:facebook_key], ENV['FACEBOOK_APP_SECRET'] || APP_CONFIG[:facebook_secret],
#   
#     :scope => 'email,user_about_me,user_location', 
#   :client_options => {  :ssl => { :ca_file => "#{Rails.root}/config/ca_bundle.crt" } 
#   }, :display => "popup"
