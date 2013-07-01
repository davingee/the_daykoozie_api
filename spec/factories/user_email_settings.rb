FactoryGirl.define do

  factory :user_email_setting do
    send_friend_followed_calendar   true
    send_new_comment                true
    

    trait :with_user do 
      association     :user
    end

  end
  
  
end