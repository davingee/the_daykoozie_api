require 'spec_helper'
require "cancan/matchers"

describe Api::V1::PasswordResetsController do

  let :password_reset_params do
    {
      :campaign_type  =>      "fun",
      # :image         =>        File.open("#{Rails.root}/data/fake_images/photo.jpg"),
    }
  end

  describe "POST create " do

    context 'authenticated' do
      
      context 'success' do
      
        it "create a new password token and set password_reset_sent_at" do
          set_basic_auth
          user = FactoryGirl.create(:user, :with_omniauth)
          post :create, :email => user.email, :format => :json
          user.reload.password_reset_sent_at.should_not be_nil
          user.reload.password_reset_token.should_not be_nil
          
          hash = { :body => response.body, :status => 200, 
            :message => eql(m("password", "create")), :type => "success" }
          response_valid?(hash)
          
        end
      end
      context 'fail' do
      
        it "should return record not found if no email is associated" do
          set_basic_auth
          user = FactoryGirl.create(:user, :with_omniauth)
          post :create, :email => "fasdoo@barter.com", :format => :json
          hash = { :body => response.body, :status => 404, 
            :message => eql(m("password", "not_found")), :type => "error" }
          response_valid?(hash)
          
        end


      end

    end

    context 'un authenticated' do
      
      context 'fail' do
      
        it "return 401 if no basic auth" do
          user = FactoryGirl.create(:user, :with_omniauth)
          post :create, :email => user.email, :format => :json
          
          hash = { :body => response.body, :status => 401, 
            :message => match(m("user", "unauthorized")), :type => "error" }
          response_valid?(hash)
          
        end


      end

    end

  end
  
  describe "Put update " do

    context 'authenticated' do
      
      context 'success' do
      
        it "create a new auth_token and changes password" do
          set_basic_auth
          user = FactoryGirl.create(:user, :with_omniauth, :with_password_token)
          user.password_reset_sent_at = Time.now - 5.minutes
          user.save
          put :update, :id => user.password_reset_token, :user => {:password => "fucker1", :password_confirmation => "fucker1"}, :format => :json
          user.reload.password_reset_sent_at.should_not be_nil
          user.reload.password_reset_token.should_not be_nil
          hash = { :body => response.body, :status => 200, 
            :message => eql(m("password", "update")), :type => "success",
            :model => user, :root => "user", 
            :model_type => :attributes, :attributes => {:authentication_token => user.authentication_token} }
          response_valid?(hash)
        end
        
      end

      context 'fail' do

        it "should return 401 if basic auth does not exist" do
          user = FactoryGirl.create(:user, :with_omniauth, :with_password_token)
          user.password_reset_sent_at = Time.now
          user.save
          put :update, :id => user.password_reset_token, :user => {:password => "fuck"}, :format => :json

          hash = { :body => response.body, :status => 401, 
            :message => match(m("user", "unauthorized")), :type => "error" }
          response_valid?(hash)
        end

        it "should return 409 if password or confirmation do not exist" do
          set_basic_auth
          user = FactoryGirl.create(:user, :with_omniauth, :with_password_token)
          user.password_reset_sent_at = Time.now
          user.save
          put :update, :id => user.password_reset_token, :user => {:password => "fuck"}, :format => :json
          user.reload.password_reset_sent_at.should_not be_nil
          user.reload.password_reset_token.should_not be_nil
          
          hash = { :body => response.body, :status => 409, 
            :message => eql(m("password", "no_password_or_confirmation")), :type => "error" }
          response_valid?(hash)
        end

      
        it "should respond with password_reset_token expired if longer then 2.hours" do
          set_basic_auth
          user = FactoryGirl.create(:user, :with_omniauth, :with_password_token)
          user.password_reset_sent_at = Time.now - 3.hours
          user.save
          put :update, :id => user.password_reset_token, :user => {:password => "not_work", :password_confirmation => "now_work"}, :format => :json
          user.reload.password_reset_sent_at.should_not be_nil
          user.reload.password_reset_token.should_not be_nil
          
          hash = { :body => response.body, :status => 409, 
            :message => eql(m("password", "update_expired")), :type => "error" }
          response_valid?(hash)
        end

        it "should respond with validation errors if password and confirmation do not match." do
          set_basic_auth
          user = FactoryGirl.create(:user, :with_omniauth, :with_password_token)
          user.password_reset_sent_at = Time.now
          user.save
          put :update, :id => user.password_reset_token, :user => {:password => "not_work", :password_confirmation => "now_work"}, :format => :json
          user.reload.password_reset_sent_at.should_not be_nil
          user.reload.password_reset_token.should_not be_nil
          user = User.first
          user.update_attributes(:password => "not_going", :password_confirmation => "to_work")

          hash = { :body => response.body, :status => 409, 
            :message => eql(JSON.parse(user.errors.to_json)), 
             :type => "error" }
          response_valid?(hash)
        end
        
      end
    end
  end
end