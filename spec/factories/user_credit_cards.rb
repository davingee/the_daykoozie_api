FactoryGirl.define do
  factory :user_credit_card do
    name                  "foo bar"
    last_four             false
    card_type             "12345"
    card_valid            true
    stripe_customer_token "12345"
    stripe_card_token     "12345"
    exp_month             "10"
    exp_year              "2013"
    
    trait :with_not_valid do 
      card_valid      false
    end

    trait :with_user do 
      association         :user, :with_geocoded
    end

  end
end
