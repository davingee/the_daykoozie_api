require 'spec_helper'

describe ContactsController do

  let :contact_params do
    {
      :name => "foo",
      :email => "foo@bar.com",
      :subject => "foo bar",
      :body => "foobar"
    }
  end
  
  def set_auth
    credentials = ActionController::HttpAuthentication::Basic.encode_credentials 'angular', 'angular_secret'
    request.env['HTTP_AUTHORIZATION'] = credentials
  end
  
  describe "POST to create a contact" do

    context 'success' do

      it "if current_user it should create a contact with user id" do
        # set_auth
        user = FactoryGirl.create(:user)
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(user.authentication_token)
        post :create, :contact => contact_params, :format => :json
        response.should be_success
        response.status.should == 200
        body = JSON.parse(response.body)
        body["contact"]["user_id"].should == @controller.current_user.id
        body["message"]["content"].should == m("contact", "create")
        body["message"]["type"].should == "success"
      end

      it "if not current_user it should create a contact without user id" do
        set_auth
        post :create, :contact => contact_params, :format => :json
        response.should be_success
        response.status.should == 200
        body = JSON.parse(response.body)
        body["contact"]["user_id"].should be_nil
        body["message"]["content"].should == m("contact", "create")
        body["message"]["type"].should == "success"
      end

    end

    context 'failure' do

      it "should show errors of validations with a 406" do
        set_auth
        post :create, :contact => contact_params.merge(:subject => ""), :format => :json
        response.should_not be_success
        response.status.should == 409
        body = JSON.parse(response.body)
        body["message"]["content"].should == JSON.parse(Contact.create(contact_params.merge(:subject => "")).errors.to_json)
        body["message"]["type"].should == "error"
      end

      it "should return 401 if not authorized" do
        user = FactoryGirl.create(:user)
        post :create, :contact => contact_params, :format => :json
        response.should_not be_success
        response.status.should == 401
        body = JSON.parse(response.body)
        body["message"]["type"].should == "error"
        body["message"]["content"].should =~  /#{m("user", "unauthorized")}/
      end

    end

  end

  describe "GET new to pull data if current_user" do

    context 'success' do
      it "should create a contact instance filled in with current_user" do
        set_auth
        user = FactoryGirl.create(:user)
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(user.authentication_token)
        get :new, :format => :json
        response.should be_success
        response.status.should == 200
        body = JSON.parse(response.body)
        body["contact"]["user_id"].should == @controller.current_user.id
        body["contact"]["email"].should == @controller.current_user.email
        body["contact"]["name"].should == @controller.current_user.name
        body["message"]["content"].should be_nil
        body["message"]["type"].should == "success"
      end

      it "if create a contact instance with no user data if no current_user" do
        set_auth
        get :new, :format => :json
        response.should be_success
        response.status.should == 200
        body = JSON.parse(response.body)
        body["contact"]["user_id"].should be_nil
        body["contact"]["email"].should be_nil
        body["contact"]["name"].should be_nil
        body["message"]["content"].should be_nil
        body["message"]["type"].should == "success"
      end

    end
    context 'fail' do
      it "should return 401 if not authorized" do
        user = FactoryGirl.create(:user)
        get :new, :format => :json
        response.should_not be_success
        response.status.should == 401
        body = JSON.parse(response.body)
        body["message"]["type"].should == "error"
        body["message"]["content"].should =~  /#{m("user", "unauthorized")}/
      end
    end
  end
  
end
