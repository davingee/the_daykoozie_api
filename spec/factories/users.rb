FactoryGirl.define do
  factory :user do
    # after(:build)       { |user| user.class.skip_callback(:create, :after, :create_braintree_customer, :update, :before, :update_address) }

    sequence(:first_name) { |n| "Scott#{n}" }
    last_name             "Smith"
    sequence(:email)      { |n| "foo#{n}@bar.com" }
    # sequence(:username)   { |n| "scott#{n}" }
    time_zone             "Eastern Time (US & Canada)"
    gender                "male"
    password              "password"
    # password_confirmation "password"
    ip_address            "206.127.79.163"
    has_been_geocoded     false
    authentication_token  "12345"

    trait :with_geocoded do 
      latitude            55.3224
      longitude           58.0843
      has_been_geocoded   true
    end

    trait :soft_deleted do 
      soft_delete        true
    end

    trait :with_campaign do
      campaigns { |c| [c.association(:campaign)] }
    end

    trait :with_password_token do
      password_reset_token "u_XHu5nnINKQy5hHK37vmhcQ"
      password_reset_sent_at "2013-06-22T22:11:40Z"
    end

    trait :with_image do 
      avatar              { File.open("#{Rails.root}/app/assets/images/default.png") }
    end

    trait :deleted do 
      soft_deleted         true
    end

    trait :with_city do 
      association         :city
    end

    trait :with_credit_card do 
      association         :user_credit_card
    end

    trait :with_omniauth do 
      user_authentications { |authentications| [authentications.association(:user_authentication)] }
      omniauth             true
    end

  end
end