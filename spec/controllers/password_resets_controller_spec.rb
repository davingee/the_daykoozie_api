require 'spec_helper'
require "cancan/matchers"

describe Api::V1::PasswordResetsController do

  let :password_reset_params do
    {
      :campaign_type  =>      "fun",
      # :image         =>        File.open("#{Rails.root}/data/fake_images/photo.jpg"),
    }
  end

  describe "GET index to show " do

    context 'authenticated' do
      
      context 'success' do
      
        it "should show all campaigns if current_user" do
          user = FactoryGirl.create(:user)
          set_token_auth(user)
        end

        it "should show all campaigns if not current_user" do
          set_basic_auth
        end

        it "should not show campaigns that soft_delete is true or published is false" do
        end

      end

    end

  end
  
end