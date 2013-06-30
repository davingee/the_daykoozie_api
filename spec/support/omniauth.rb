module Omniauth
# background   do
  #    set_omniauth()
  #    click_link_or_button 'Sign up with Facebook'
  # end


  def set_omniauth(opts = {})
    default = {
      :provider => :facebook,
      :uuid  => "1234",
      :facebook => {
        :email => "foobar@example.com",
        :gender => "Male",
        :first_name => "Scott",
        :last_name => "Smith",
        :nick_name => "davinj",
        :location => "Seattle WA"
      }
    }
 
    credentials = default.merge(opts)
    provider = credentials[:provider]
    user_hash = credentials[provider]
 
    OmniAuth.config.test_mode = true
 
    OmniAuth.config.mock_auth[provider] = {
      #   :provider => credentials[:provider],
      #   :uid => credentials[:uuid],
      #   "info" => {
      #     :nickname => user_hash[:nick_name],
      #     :email => user_hash[:email],
      #     :name => 'Scott Smith',
      #     :first_name => user_hash[:first_name],
      #     :last_name => user_hash[:last_name],
      #     :image => 'http://graph.facebook.com/1234567/picture?type=square',
      #     :urls => { :Facebook => 'http://www.facebook.com/jbloggs' },
      #     :location => user_hash[:location],
      #     :verified => true
      #   },
      #   :credentials => {
      #     :token => 'ABCDEF...', # OAuth 2.0 access_token, which you may wish to store
      #     :expires_at => 1321747205, # when the access token expires (it always will)
      #     :expires => true # this will always be true
      #   },
      #   :extra => {
      #     :raw_info => {
      #       :id => '1234567',
      #       :name => 'Joe Bloggs',
      #       :first_name => user_hash[:first_name],
      #       :last_name => user_hash[:last_name],
      #       :link => 'http://www.facebook.com/jbloggs',
      #       :username => user_hash[:nick_name],
      #       :location => { :id => '123456789', :name => user_hash[:location] },
      #       :gender => user_hash[:gender],
      #       :email => user_hash[:email],
      #       :timezone => -6,
      #       :locale => 'en_US',
      #       :verified => true,
      #       :updated_time => '2011-11-11T06:21:03+0000'
      #     }
      #   }
      # }

      'uid' => credentials[:uuid],
      "extra" => {
      "user_hash" => {
        "email" => user_hash[:email],
        "first_name" => user_hash[:first_name],
        "last_name" => user_hash[:last_name],
        "gender" => user_hash[:gender]
        }
      }
    }
  end
 
  def set_invalid_omniauth(opts = {})
  
    credentials = { :provider => :facebook,
                    :invalid  => :invalid_crendentials
                   }.merge(opts)
  
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[credentials[:provider]] = credentials[:invalid]
 
  end 
end