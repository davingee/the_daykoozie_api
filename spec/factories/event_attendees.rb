FactoryGirl.define do

  factory :event_attendee do


    trait :with_user do 
      association     :user
    end
    
    trait :with_calendar do 
      association     :event
    end

  end
  
  
end