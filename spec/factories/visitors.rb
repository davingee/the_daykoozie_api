FactoryGirl.define do
  factory :visitor do

    ip_address            "206.127.79.163"
    has_been_geocoded     false
    authentication_token  "12345"

    trait :with_geocoded do 
      latitude            55.3224
      longitude           58.0843
      has_been_geocoded   true
    end

  end

end