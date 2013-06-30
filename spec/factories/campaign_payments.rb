FactoryGirl.define do
  factory :campaign_payment do
    amount          1000.00
    transaction_id  "asdfasdfadsfadsf"

    trait :with_campaign do 
      association     :campaign
    end

    trait :with_user do 
      association         :user
    end

    trait :with_geocoded_user do 
      association         :user, :with_geocoded
    end
    
  end
end