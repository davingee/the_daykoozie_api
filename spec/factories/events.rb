FactoryGirl.define do

  factory :event do
    feed_url             "http://google.com"
    title            "Title"
    etag              "12345"

    author            "foo bar"
    summary           "some summary"
    content           "some content"
    start_time        Time.now
    end_time          Time.now
    # image             File.open("#{Rails.root}/data/fake_images/photo.jpg")
    last_modified     Time.now
    published         Time.now
    url               "http://google.com"
    all_day           false

    trait :with_geocoded do 
      latitude            55.3224
      longitude           58.0843
      has_been_geocoded   true
    end

    trait :with_user do 
      association     :user
    end
    
    trait :with_calendar do 
      association     :calendar
    end

  end
  
  
end