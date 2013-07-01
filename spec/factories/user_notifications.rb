FactoryGirl.define do

  factory :user_notification do
    role                  "admin"
    kind                  "something figure out"
    state                 :active
    # notificationable_type 
    # notificationable_id
    # user_id
    

    trait :with_user do 
      association     :user
    end

  end
  
  
end