FactoryGirl.define do
  factory :share do
    ip_address          "206.127.79.163"
    shared_with         "facebook"
    has_been_geocoded   false
    spam                false
    entered_into_neo4j  true
    
    trait :with_entered_into_neo4j do 
      entered_into_neo4j true
    end
    
    trait :with_spam do
      spam                true
    end
    
    trait :with_geocoded do 
      latitude            55.3224
      longitude           58.0843
      has_been_geocoded   true
    end
    
    trait :with_campaign do 
      association         :campaign, :with_user
    end

    trait :with_visitor do 
      association         :visitor, :with_geocoded
    end

    trait :with_geocoded_visitor do 
      association         :visitor, :with_geocoded
    end

    trait :with_user do 
      association         :user
    end

    trait :with_geocoded_user do 
      association         :user, :with_geocoded
    end

  end
end
