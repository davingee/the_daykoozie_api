FactoryGirl.define do
  factory :outgoing_payment do

    amount              20.00
    verification_token  "12345"
    provider            "paypal"
    email               "foo@bar.com"

    trait :with_user do 
      association         :user
    end

    trait :with_geocoded_user do 
      association         :user, :with_geocoded
    end

  end
end
