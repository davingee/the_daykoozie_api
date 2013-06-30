FactoryGirl.define do
  factory :campaign do

    # association         :user, :with_geocoded
    campaign_type       :fun
    budget              1000
    sequence(:title)      { |n| "Nike Shoes" }
    # title               "Nike Shoes"
    blurb               "Great pear of shoo's "
    content             "Somethings got to be greater then this pear of shooos"
    start_date          Time.now 
    published           true
    local               [true, false].sample
    # image               File.open("#{Rails.root}/data/fake_images/#{IMAGES.sample}")
    keyword_list        ["foo", "bar"]
    url                 "http://www.avaaz.org/en/stop_frankenfish_r/?fpbr"
    wants_to_spend      1000
    amount_to_ancestor  0.10
    secret              false
    # campaign_roles { |roles| [roles.association(:campaign_role)] }
  
    # trait :promo_code
    #   promo_code = :promo_code
    # end

    trait :with_user do
      association         :user, :with_geocoded
    end
  
    trait :moral do
      campaign_type = :moral
    end

    trait :fun do
      campaign_type = :fun
    end

    trait :not_published do
      published  false
    end
    
    trait :deleted do
      soft_delete  true
    end

    trait :commercial do
      campaign_type = :commercial
      amount_to_ancestor = 0.10
      wants_to_spend   = 10000
      campaign_payments { |payments| [payments.association(:campaign_payment)] }
    end

    trait :with_prizes do
      campaign_type = :commercial
      amount_to_ancestor = 0.10
      wants_to_spend   = 10000
      campaign_payments { |payments| [payments.association(:campaign_payment)] }
      campaign_prizes { |prizes| [prizes.association(:campaign_prize)] }
    end
    
  end
end
