FactoryGirl.define do
  factory :calendar_role do
    role       :admin

    trait :with_user do 
      association                 :user
    end

    trait :with_calendar do 
      association                 :calendar
    end

  end
end
