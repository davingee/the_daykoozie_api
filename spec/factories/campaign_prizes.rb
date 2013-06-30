FactoryGirl.define do
  factory :campaign_prize do

    name            "Xbox"
    amount          100.00
    retail_price    200.00
    description     "Xbox yo"
    prize_for       "1st place"
    prize_kind      "most countries"
    # image               File.open("#{Rails.root}/data/fake_images/#{IMAGES.sample}")

    trait :with_campaign do
      association     :campaign
    end

  end
end