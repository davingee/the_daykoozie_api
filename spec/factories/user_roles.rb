FactoryGirl.define do

  factory :user_role do
    role            "admin"
  end
  
  trait :with_user do 
    association     :user
  end
  
end