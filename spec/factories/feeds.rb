FactoryGirl.define do

  factory :feed do
    url             "http://google.com"
    etag            "12345"
    last_modified   Time.now
    published       Time.now
    kind            "something"

    trait :with_user do 
      association     :user
    end
    
    trait :with_calendar do 
      association     :calendar
    end

  end
  
  
end