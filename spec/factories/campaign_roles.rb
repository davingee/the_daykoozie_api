FactoryGirl.define do
  factory :campaign_role do

    role              :admin
    sequence(:email)  { |n| "foo#{n}@bar.com" }
    # inviter_id        

    trait :with_user do 
      association       :user
    end
    
    trait :with_campaign do 
      association       :campaign
    end
    
    trait :admin do
      role :admin
    end

    trait :manager do
      role :manager
    end

    trait :viewer do
      role :viewer
    end

  end

end