FactoryGirl.define do
  factory :calendar do
    title       "Foo Bar"
    description    "Foo Bar Description"
    secret        false       
    # image             File.open("#{Rails.root}/data/fake_images/photo.jpg")

    trait :with_user do 
      association                 :user
    end

  end
end
