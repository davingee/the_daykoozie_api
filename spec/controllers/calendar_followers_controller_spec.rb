require 'spec_helper'
describe Api::V1::CalendarFollowersController do

  let :calendar_follower_params do
    {
      :calendar_id        => "Foo Bar",
      :user_id  => "Foo Bar Description"
    }
  end

  describe "GET index to show all calendar_roles associated with calendar" do

    context 'authenticated' do
      
      context 'success' do
      
        it "should show all calendar roles from calendar" do
          user = set_token_auth_with_user
          user_2 = FactoryGirl.create(:user)

          calendar = FactoryGirl.create(:calendar, :user_id => user_2.id)
          
          get :index, :calendar_id => calendar.id, :format => :json 
          calendar_roles = calendar.reload.calendar_roles
          hash = { :body => response.body, :status => 200, 
            :type => "success", :root => "calendar_roles", :models => calendar_roles, :models_count => 1 }
          response_valid?(hash)

        end

        it "should show all calendar roles from calendar" do
          user = set_token_auth_with_user
          calendar = FactoryGirl.create(:calendar, :user_id => user.id)
          calendar_role = calendar.reload.calendar_roles.first
          calendar_role.role = :admin
          calendar_role.save
          get :index, :calendar_id => calendar.id, :format => :json 
          calendar_roles = calendar.reload.calendar_roles
          hash = { :body => response.body, :status => 200, 
            :type => "success", :root => "calendar_roles", :models => calendar_roles, :models_count => 1 }
          response_valid?(hash)

        end

      end

    end

    context 'not authenticated' do

      context 'failure' do
      
        it "should not show calendar roles if no permissions" do
          user = set_token_auth_with_user
          calendar_of_user = FactoryGirl.create(:calendar, :user_id => user.id)
          calendar = FactoryGirl.create(:calendar, :user_id => FactoryGirl.create(:user).id)
          get :index, :calendar_id => calendar.id, :format => :json 
          hash = { :body => response.body, :status => 401, 
            :type => "error", :root => false,             
            :message => match(m("calendar", "unauthorized")) }
          response_valid?(hash)
        end

        it "should not show calendar roles" do
          user = set_token_auth_with_user
          calendar = FactoryGirl.create(:calendar, :user_id => user.id)
          calendar_role = calendar.reload.calendar_roles.first
          calendar_role.role = :follower
          calendar_role.save
          get :index, :calendar_id => calendar.id, :format => :json 
          hash = { :body => response.body, :status => 401, 
            :type => "error", :root => false,             
            :message => match(m("calendar", "unauthorized")) }
          response_valid?(hash)
        end
      
      end

    end

  end

  
  describe "POST to create a calendar" do

    context 'success' do

      it "should create a calendar" do
        user = set_token_auth_with_user
        user_2 = FactoryGirl.create(:user)
        calendar = FactoryGirl.create(:calendar, :user_id => user_2.id)
        post :create, :calendar_id => calendar.id, :format => :json 
        calendar_follower = calendar.reload.calendar_followers.first
        puts calendar_follower.inspect
        hash = { :body => response.body, :status => 200, :message => eql(m("calendar_follower", "create")),
          :type => "success", :root => "calendar_follower", :model => calendar_follower,
          :model_type => :attributes, :attributes => { :user_id => user.id, :calendar_id => calendar.id } }
        response_valid?(hash)
      end

    end

    context 'failure' do
      
      it "should not create calendar role if no permisions" do
        user = set_token_auth_with_user
        user2 = FactoryGirl.create(:user)
        calendar = FactoryGirl.create(:calendar, :user_id => user2.id)
        post :create, :calendar_id => calendar.id, :calendar_role => { :user_id => 5, :role => :admin }, :format => :json 
        puts response.body
        
        hash = { :body => response.body, :status => 401, 
          :type => "error", :root => false,             
          :message => match(m("calendar", "unauthorized")) }
        response_valid?(hash)
      end

      it "should return 401 if no basic auth exists or is correct" do
        user = set_token_auth_with_user
        calendar = FactoryGirl.create(:calendar, :user_id => user.id)
        calendar_role = calendar.reload.calendar_roles.first
        calendar_role.role = :follower
        calendar_role.save
        post :create, :calendar_id => calendar.id, :calendar_role => { :user_id => 5, :role => :admin }, :format => :json 
        hash = { :body => response.body, :status => 401, 
          :type => "error", :root => false,             
          :message => match(m("calendar", "unauthorized")) }
        response_valid?(hash)
      end

    end

  end

  describe "Delete to  delete a calendar" do

    context 'success' do
      it "should destroy the calendar" do
        user = set_token_auth_with_user
        calendar = FactoryGirl.create(:calendar, :user_id => user.id)
        user2 = FactoryGirl.create(:user)
        calendar_role = calendar.calendar_roles.create(:user_id => user2.id, :role => :admin)
        puts calendar_role.inspect
        delete :destroy, :calendar_id => calendar.id, :id => calendar_role.id, :format => :json 
        puts response.body
        hash = { :body => response.body, :status => 200, :message => eql(m("calendar_role", "destroy")),
          :type => "success", :root => false }
        response_valid?(hash)
      end
    end

    context 'failure' do
      
      it 'should not destroy if no current_user' do
      end

      it 'should not destroy if current_user does not have permaisions' do
      end


    end

  end

end
