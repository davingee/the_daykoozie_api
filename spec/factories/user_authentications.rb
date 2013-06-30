FactoryGirl.define do
  factory :user_authentication do

    uid                 "12345"
    provider            "facebook"

    trait :with_user do 
      association         :user
    end


  end
end