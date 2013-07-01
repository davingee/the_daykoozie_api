require 'spec_helper'
describe Api::V1::UsersController do

  let :calendar_params do
    {
      :title        => "Foo Bar",
      # image       => File.open("#{Rails.root}/data/fake_images/photo.jpg"),
      # image       => "#{Rails.root}/data/fake_images/photo.jpg",
      :description  => "Foo Bar Description"
    }
  end

  describe "GET index to show all calendars" do

    context 'authenticated' do
      
      context 'success' do
      
        it "should show all users except soft_deleted" do
          user = set_token_auth_with_user
          FactoryGirl.create(:calendar)
          FactoryGirl.create(:calendar)
          get :index, :format => :json

          hash = { :body => response.body, :status => 200, 
            :type => "success", 
            :root => "calendars", 
            :models => Calendar.all }
          response_valid?(hash)
          @controller.current_user.id.should == user.id
        end

        it "should show also show events" do
          user = set_token_auth_with_user
          FactoryGirl.create(:calendar)
          FactoryGirl.create(:calendar)
          get :index, :format => :json
          
          hash = { :body => response.body, :status => 200, 
            :type => "success", 
            :root => "calendars", 
            :models => Calendar.all }
          response_valid?(hash)
          @controller.current_user.id.should == user.id
        end

      end

    end

    context 'not authenticated' do

      context 'success' do
      
        it "should show all users except soft_deleted" do
          FactoryGirl.create(:user)
          FactoryGirl.create(:user)
          FactoryGirl.create(:user, :soft_deleted)
          get :index, :format => :json
          hash = { :body => response.body, :status => 200, 
            :type => "success", 
            :root => "users", 
            :models => User.to_show }
          response_valid?(hash)
        end
      
      end

    end

  end

  describe "GET show to show specific user" do

    context 'authenticated' do
      
      context 'success' do
      
        it "should show specific user except soft_deleted" do
          user = set_token_auth_with_user
          user2 = FactoryGirl.create(:user)
          get :show, :id => user2.id, :format => :json

          hash = { :body => response.body, :status => 200, 
            :type => "success", :root => "user", :model => user,
            :model_type => :attributes, :attributes => { :id => user2.id, :email => nil } }
          response_valid?(hash)

        end

      end

    end

    context 'not authenticated' do

      context 'success' do
      
        it "should show specific user except soft_deleted" do
          user = FactoryGirl.create(:user)
          get :show, :id => user.id, :format => :json
          hash = { :body => response.body, :status => 200, 
            :type => "success", :root => "user", :model => user,
            :model_type => :attributes, :attributes => { :id => user.id, :email => nil } }
          response_valid?(hash)
        end
      
      end

      context 'failure' do
        it "should not show a user that has been soft_deleted" do
          user = FactoryGirl.create(:user, :soft_deleted)
          get :show, :id => user.id, :format => :json
          hash = { :body => response.body, :status => 404, 
            :type => "error", :root => false, :message => match(m("rescue", "RecordNotFound")) }
          response_valid?(hash)

        end

      end

    end

  end
  
  describe "POST to register a user" do

    context 'success' do

      it "should return user with api_key to the logged in user" do
        set_basic_auth
        User.any_instance.stubs(:create_stripe_customer).returns(true)
        post :create, :user => user_params, :format => :json 
        user = User.first
        hash = { :body => response.body, :status => 200, 
          :type => "success", :root => "user", :model => user,
          :message => eql( m("user", "create")),
          :model_type => :attributes, :attributes => { :id => user.id, :email => nil, :authentication_token => user.authentication_token } }
        response_valid?(hash)

      end

    end

    context 'failure' do
      
      it "should show validations if  user doesn't have all fields right" do
        set_basic_auth
        post :create, :user => user_params.merge(:first_name => ''), :format => :json
        hash = { :body => response.body, :status => 409, 
          :type => "error", :root => "user", 
          :message => eql(JSON.parse(User.create(user_params.merge(:first_name => '')).errors.to_json)),
          :model_type => :attributes, :attributes => { :id => nil, :first_name => '', :email => nil } }
        response_valid?(hash)

      end

      it "should return 401 if no basic auth exists or is correct" do
        post :create, :user => user_params, :format => :json
        hash = { :body => response.body, :status => 401, 
          :type => "error", :root => false,
          :message => match(m("user", "unauthorized")) }
        response_valid?(hash)
      end

    end

  end

  describe "GET to edit a user" do

    context 'success' do
      it "should return user data if logged in" do
        user = set_token_auth_with_user
        get :edit, :format => :json

        hash = { :body => response.body, :status => 200, 
          :type => "success", :root => "user", :model => user,
          :model_type => :attributes, :attributes => { :id => user.id, :first_name => user.first_name, :email => user.email, :authentication_token => user.authentication_token } }
          response_valid?(hash)
      end
    end
    
    context 'error' do
      it "should return 401 if user not logged in" do
        user = FactoryGirl.create(:user)
        get :edit, :format => :json
        hash = { :body => response.body, :status => 401, 
          :message => match(m("user", "unauthorized")), :type => "error", 
          :root => false }
        response_valid?(hash)

      end
    end
  end

  describe "Put to update a user" do

    context 'success' do
      it "should return user with updated attributes to the logged in user" do
        user = set_token_auth_with_user
        get :update, :user => {:first_name => "dooper"}, :format => :json

        hash = { :body => response.body, :status => 200, 
          :type => "success", :root => "user",  :model => user, 
          :message => eql(m("user", "update")),
          :model_type => :attributes, :attributes => { :id => user.id, :first_name => 'dooper', :email => user.email } }
        response_valid?(hash)
        
      end
    end

    context 'error' do

      it "should return validation errors if any" do
        user = set_token_auth_with_user(:with_omniauth => true)
        get :update, :user => {:first_name => ""}, :format => :json
        hash = { :body => response.body, :status => 409, 
          :type => "error", :root => "user",
          :message => eql(JSON.parse(User.create(user_params.merge(:email => "scott@scoran.com", :first_name => "")).errors.to_json)) }
        response_valid?(hash)
      end

      it "should return 401 unauthorized if user not logged in" do
        user = FactoryGirl.create(:user)
        get :update, :user => {:first_name => "dooper"}, :format => :json
        hash = { :body => response.body, :status => 401, 
          :type => "error", :root => false,
          :message => match(m("user", "unauthorized")) }
        response_valid?(hash)

      end
    end

  end

  describe "Delete to soft delete a user" do

    context 'success' do
      it "should make soft_delete = to true" do
        user = set_token_auth_with_user
        delete :destroy, :format => :json
        hash = { :body => response.body, :status => 200, 
          :type => "success", :root => false,
          :message => eql(m("user", "destroy")) }
        response_valid?(hash)
      end
    end

    context 'failure' do
      
      it 'should not make soft_delete = to true if no current_user' do
        delete :destroy, :format => :json
        hash = { :body => response.body, :status => 401, 
          :type => "error", :root => false,
          :message => eql(m("user", "unauthorized")) }
        response_valid?(hash)
      end

    end

  end

end
