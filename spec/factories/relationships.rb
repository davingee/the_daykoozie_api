FactoryGirl.define do
  # user = create(:user, :with_omniauth)
  factory :relationship do
    # follower_id   user.id
    # followed_id   FactoryGirl.create(:user, :with_omniauth).id

    trait :with_user do 
      association     :user
    end

  end
  
  
end