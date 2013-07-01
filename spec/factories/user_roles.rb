FactoryGirl.define do

  factory :user_role do
    role            "admin"

    trait :with_user do 
      association     :user
    end

  end
  
  
end