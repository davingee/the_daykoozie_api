FactoryGirl.define do
  factory :calendar_follower do


    trait :with_user do 
      association                 :user
    end

    trait :with_calendar do 
      association                 :calendar
    end

  end
end
