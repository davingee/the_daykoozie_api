FactoryGirl.define do
  factory :contact do
    name       "Foo Bar"
    email      "foo@bar.com"
    subject    "test subject"
    body       "Hi I like your website and have a few questions"
    ip_address "206.127.79.163"

    trait :with_user do 
      association                 :user
    end

  end
end
