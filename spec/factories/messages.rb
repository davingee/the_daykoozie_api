FactoryGirl.define do

  factory :message do
    
    body        "Hellow"
    deleted     false

    trait :with_user do 
      association     :user
    end
    
    trait :with_calendar do 
      association     :calendar
    end

    trait :with_event do 
      association     :event
    end

    trait :with_parent do 
      # parent_id     FactoryGirl.create(:message).id
    end

  end
  
  
end