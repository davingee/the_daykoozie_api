require 'spec_helper'
describe Api::V1::UsersController do

  let :user_params do
    {
      :first_name => "foo",
      :last_name => "bar",
      :email => "fodo@bar.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
  end

  describe "GET index to show all users" do

    context 'authenticated' do
      
      context 'success' do
      
        it "should show all users except soft_deleted" do
          user = FactoryGirl.create(:user)
          FactoryGirl.create(:user)
          FactoryGirl.create(:user, :soft_deleted)
          request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(user.authentication_token)
          get :index, :format => :json
          response.should be_success
          response.status.should == 200
          @controller.current_user.id.should == user.id
          body = JSON.parse(response.body)
          body["users"].count.should == 2
          body["message"]["content"].should be_nil
          body["message"]["type"].should == "success"
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
          response.should be_success
          response.status.should == 200
          @controller.current_user.should be_nil
          body = JSON.parse(response.body)
          body["users"].count.should == 2
          body["message"]["content"].should be_nil
          body["message"]["type"].should == "success"
        end
      
      end

    end

  end

  describe "GET show to show specific user" do

    context 'authenticated' do
      
      context 'success' do
      
        it "should show specific user except soft_deleted" do
          user = FactoryGirl.create(:user)
          user2 = FactoryGirl.create(:user)
          request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(user.authentication_token)
          get :show, :id => user2.id, :format => :json
          response.should be_success
          response.status.should == 200
          body = JSON.parse(response.body)
          body["user"]["id"].should == user2.id
          body["message"]["content"].should be_nil
          body["message"]["type"].should == "success"
        end

      end

    end

    context 'not authenticated' do

      context 'success' do
      
        it "should show specific user except soft_deleted" do
          user = FactoryGirl.create(:user)
          get :show, :id => user.id, :format => :json
          response.should be_success
          response.status.should == 200
          body = JSON.parse(response.body)
          body["user"]["id"].should == user.id
          body["message"]["content"].should be_nil
          body["message"]["type"].should == "success"
        end
      
      end

      context 'failure' do
        it "should not show a user that has been soft_deleted" do
          user = FactoryGirl.create(:user, :soft_deleted)
          get :show, :id => user.id, :format => :json
          response.should_not be_success
          response.status.should == 404
          body = JSON.parse(response.body)
          body["message"]["content"].should =~ /#{m("rescue", "RecordNotFound")}/
          body["message"]["type"].should == "error"
        end

      end

    end

  end
  
  describe "POST to register a user" do

    context 'success' do

      it "should return user with api_key to the logged in user" do
        credentials = ActionController::HttpAuthentication::Basic.encode_credentials 'angular', 'angular_secret'
        request.env['HTTP_AUTHORIZATION'] = credentials
        post :create, :user => user_params, :format => :json 
        response.should be_success
        response.status.should == 200
        body = JSON.parse(response.body)
        User.find(body["user"]["id"]).should_not be_nil
        User.find_by_authentication_token(body["user"]["authentication_token"]).should_not be_nil
        body = JSON.parse(response.body)
        body["user"]["id"].should == User.first.id
        body["message"]["type"].should == "success"
        body["message"]["content"].should == m("user", "create")
      end

    end

    context 'failure' do
      
      it "should show validations if  user doesn't have all fields right" do
        credentials = ActionController::HttpAuthentication::Basic.encode_credentials 'angular', 'angular_secret'
        request.env['HTTP_AUTHORIZATION'] = credentials
        post :create, :user => user_params.merge(:first_name => ''), :format => :json
        response.should_not be_success
        response.status.should == 409
        # @controller.current_user.should be_nil
        body = JSON.parse(response.body)
        body["user"]["last_name"].should == "bar"
        body["message"]["content"].should == JSON.parse(User.create(user_params.merge(:first_name => '')).errors.to_json)
        body["message"]["type"].should == "error"
      end

      it "should show validations if  user doesn't have all fields right" do
        credentials = ActionController::HttpAuthentication::Basic.encode_credentials 'angular', 'angular_secret'
        request.env['HTTP_AUTHORIZATION'] = credentials
        post :create, :user => user_params.merge(:password => 'wrong match'), :format => :json
        response.should_not be_success
        response.status.should == 409
        # @controller.current_user.should be_nil
        body = JSON.parse(response.body)
        body["user"]["last_name"].should == "bar"
        body["message"]["content"].should == JSON.parse(User.create(user_params.merge(:password => 'wrong match')).errors.to_json)
        body["message"]["type"].should == "error"
      end

    end

  end

  describe "GET to edit a user" do

    context 'success' do
      it "should return user data if logged in" do
        user = FactoryGirl.create(:user)
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(user.authentication_token)
        get :edit, :format => :json
        response.should be_success
        response.status.should == 200
        body = JSON.parse(response.body)
        body["message"]["type"].should == "success"
        body["message"]["content"].should be_nil
      end
    end
    
    context 'error' do
      it "should return 401 if user not logged in" do
        user = FactoryGirl.create(:user)
        get :edit, :format => :json
        response.should_not be_success
        response.status.should == 401
        body = JSON.parse(response.body)
        body["message"]["type"].should == "error"
        body["message"]["content"].should =~  /#{m("user", "unauthorized")}/
      end
    end
  end

  describe "Put to update a user" do

    context 'success' do
      it "should return user with api_key to the logged in user" do
        user = FactoryGirl.create(:user)
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials("#{user.authentication_token}")
        get :update, :user => {:first_name => "dooper"}, :format => :json
        puts response.body
        response.should be_success
        response.status.should == 200
        body = JSON.parse(response.body)
        body["user"]["first_name"].should == "dooper"
        body["message"]["type"].should == "success"
        body["message"]["content"].should == m("user", "update")
        
      end
    end

    context 'error' do
      it "should return 401 unauthorized if user not logged in" do
        user = FactoryGirl.create(:user)
        get :update, :user => {:first_name => "dooper"}, :format => :json
        response.should_not be_success
        response.status.should == 401
        body = JSON.parse(response.body)
        body["message"]["type"].should == "error"
        body["message"]["content"].should =~  /#{m("user", "unauthorized")}/
      end
    end

  end

  describe "Delete to soft delete a user" do

    context 'success' do
      it "should make soft_delete = to true" do
        user = FactoryGirl.create(:user)
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(user.authentication_token)
        delete :destroy, :format => :json
        response.should be_success
        response.status.should == 200
        user.reload
        user.authentication_token.should be_nil
        body = JSON.parse(response.body)
        body["message"]["type"].should == "success"
        body["message"]["content"].should == m("user", "destroy")
      end
    end

    context 'failure' do
      it 'should not make soft_delete = to true if no current_user' do
        delete :destroy, :format => :json
        response.should_not be_success
        response.should_not be_success
        response.status.should == 401
        body = JSON.parse(response.body)
        body["message"]["type"].should == "error"
        body["message"]["content"].should =~  /#{m("user", "unauthorized")}/
      end

    end

  end

end
