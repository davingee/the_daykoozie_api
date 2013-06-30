require 'spec_helper'

describe Api::V1::TokensController do

  describe "POST to login  a user" do

    context 'success' do
      it "should set current_user to the logged in user" do
        user = set_basic_auth_with_user
        
        post :create, {:email => user.email, :password => user.password, :format => :json }
        
        hash = { :body => response.body, :status => 200, 
          :message => eql(m("token", "create")), :type => "success", 
          :root => "user", :model => user }
        response_valid?(hash)
        
      end
    end

    context 'failure' do
      it 'should fail when wrong password is entered' do
        user = set_basic_auth_with_user
        post :create, {:email => user.email, :password => "not_valid_password", :format => :json }

        hash = { :body => response.body, :status => 401, 
          :message => eql(m("token", "invalid")), :type => "error" }
        response_valid?(hash)

      end

      it 'should fail when the email is not correct' do
        user = set_basic_auth_with_user

        post :create, {:email => "not@real.com", :password => user.password, :format => :json }

        hash = { :body => response.body, :status => 401, 
          :message => eql(m("token", "invalid")), :type => "error" }
        response_valid?(hash)

      end

      it 'should fail when no basic auth is given' do
        user = FactoryGirl.create(:user)
        post :create, {:email => user.email, :password => user.password, :format => :json }
        hash = { :body => response.body, :status => 401, 
          :message => eql(m("user", "unauthorized")), :type => "error" }
        response_valid?(hash)

      end

    end

  end


  describe "Delete to log out a user" do

    context 'success' do
      it "should destroy session cookie and current_user" do
        user = set_token_auth_with_user
        delete :destroy, :format => :json
        user.reload
        user.authentication_token.should be_nil
        @controller.current_user.should be_nil

        hash = { :body => response.body, :status => 200, 
          :message => eql(m("token", "destroy")), :type => "success" }
        response_valid?(hash)

      end
    end

    context 'failure' do
      
      it 'should respond with status 401 when no user exists' do
        delete :destroy, :format => :json

        @controller.current_user.should be_nil

        hash = { :body => response.body, :status => 401, 
          :message => eql(m("user", "unauthorized")), :type => "error" }
        response_valid?(hash)

      end

    end

  end

end
