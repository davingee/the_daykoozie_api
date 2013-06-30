FactoryGirl.define do

  # factory :educated_employed_user, :parent => :user do
  #   user_universities { |universities| [universities.association(:user_university)] }
  #   user_jobs { |jobs| [jobs.association(:user_job)] }
  # end
  # 
  # factory :employed_user, :parent => :user do
  #   user_jobs { |jobs| [jobs.association(:user_job)] }
  # end
  # 
  # factory :educated_user, :parent => :user do
  #   user_universities { |universities| [universities.association(:user_university)] }
  # end
  # 
  # factory :user_with_address, :parent => :user do
  #   user_address { |address| [address.association(:user_address)] }
  # end
  # 
  # factory :task_with_bids, :parent => :task do
  #   bids { |the_bid| [the_bid.association(:bid)] } # something wrong with the task being created_twice
  # end

end
