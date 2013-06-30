FactoryGirl.define do
  factory :visit do
    ip_address      "206.127.79.163"
    user_agent      false
    referer         "12345"
    shared_with    "facebook"

    trait :with_visitor do 
      association         :visitor, :with_geocoded
    end

    trait :with_geocoded_visitor do 
      association         :visitor, :with_geocoded
    end

    trait :with_user do 
      association         :user
    end

    trait :with_geocoded_user do 
      association         :user, :with_geocoded
    end

  end
end