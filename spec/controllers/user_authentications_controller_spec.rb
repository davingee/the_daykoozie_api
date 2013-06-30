require 'spec_helper'
describe Api::V1::UserAuthenticationsController do

  def stub_env_for_omniauth(email)
    env = {
      "omniauth.auth" => { 
        "provider" => "facebook",
        "uid" => "12345",
        "info" => { 
          "nickname" => "foobar", 
          "email" => email, 
          "first_name" => "foo", 
          "last_name" => "bar", 
          "location" => "seattle wa"
        },
        "extra" => { 
          "raw_info" => { 
            "gender" => "male" 
          } 
        } 
      }
    }
    subject.stubs(:env => env)
  end

  let :user_params do
    {
      :first_name => "foo",
      :last_name => "bar",
      :email => "fodo@bar.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
  end

  def stub_env_for_invalid_omniauth(email)
    env = {
      "omniauth.auth" => { 
        "provider" => "",
        "uid" => "12345",
        "info" => { 
          "nickname" => "foobar", 
          "email" => email, 
          "first_name" => "foo", 
          "last_name" => "bar", 
          "location" => "seattle wa"
        },
        "extra" => { 
          "raw_info" => { 
            "gender" => "male" 
          } 
        } 
      }
    }
    subject.stubs(:env => env)
  end
  
  describe "GET index of user_authentications" do

    context 'success' do
      it "should get all user_authentications" do
        user = set_token_auth_with_user

        get :index

        hash = { :body => response.body, :status => 200, 
          :type => "success", 
          :root => "user_authentications", :model => user.user_authentications.first, 
          :model_type => :first_id }
        response_valid?(hash)

      end
    end

    context 'fail' do

      it "should not show authentications if not logged in" do
        user = FactoryGirl.create(:user, :with_omniauth)
        get :index

        hash = { :body => response.body, :status => 401, 
          :message => match(m("user", "unauthorized")), :type => "error" }
        response_valid?(hash)

      end
    end
  end
  
  describe "POST create for facebook" do

    context 'success' do
      it "should create a user from omniauth" do
        set_basic_auth
        stub_env_for_omniauth("foo@bar.com")
        post :create
        
        user = User.first
        user.user_authentications.first.user_id == user.id
        user.user_authentications.first.provider == "facebook"
        user.user_authentications.first.uid == "12345"
        
        hash = { :body => response.body, :status => 200, 
          :message => eql(m("user_authentication.facebook", "create")), :type => "success", 
          :root => "user", :model => user }
        response_valid?(hash)

      end
      
      it "should create a user_authentication if current_user" do

        stub_env_for_omniauth("foo@bar.com")
        user = set_token_auth_with_user
        post :create
        user.user_authentications.first.user_id.should == @controller.current_user.id
        user.user_authentications.first.provider.should == "facebook"
        user.user_authentications.first.uid.should == "12345"

        hash = { :body => response.body, :status => 200, 
          :message => eql(m("user_authentication.facebook", "update")), :type => "success", 
          :root => "user", :model => user }
        response_valid?(hash)
     end

      it "should not create a user_authentication if email exists" do
        user = set_basic_auth_with_user
        stub_env_for_omniauth(user.email)
        post :create
        user.user_authentications.should be_blank

        hash = { :body => response.body, :status => 406, 
          :message => eql(m("user_authentication.facebook", "authenticate_first")),
          :type => "error" }
        response_valid?(hash)

      end

      it "log a user in if user_authentication exists" do
        hash = {:with_omniauth => true}
        user = set_basic_auth_with_user(hash)
        stub_env_for_omniauth("foo@bar.com")
        token = user.authentication_token
        post :create
        user.reload
        user.authentication_token.should_not be_nil
        user.authentication_token.should_not == token

        hash = { :body => response.body, :status => 200, 
          :message => eql(m("user_authentication.facebook", "login")), :type => "success", 
          :root => "user", :model => user }
        response_valid?(hash)

      end
      
    end

    context "failure" do 
      it "returns error if wrong information" do
        set_basic_auth
        stub_env_for_invalid_omniauth("foo@bar.com")
        post :create

        hash = {
          :body => response.body, 
          :status => 422, 
          :message => eql(m("user_authentication", "fail")), 
          :type => "error" 
        }
        response_valid?(hash)
      end

      it "returns validation messages if validations arise." do
        set_basic_auth
        stub_env_for_omniauth("bar.com")
        post :create

        hash = {
          :body => response.body, 
          :status => 409, 
          :message => eql(JSON.parse(User.create(user_params.merge(:email => "bar.com")).errors.to_json)), 
          :type => "error",
          :root => "user",
          :model_type => :attributes, :attributes => {:id => nil, :first_name => "foo"}
        }
        response_valid?(hash)

      end

      it "returns 401 if no head username password." do
        stub_env_for_omniauth("bar.com")
        post :create

        hash = {
          :body => response.body, 
          :status => 401, 
          :message => match(m("user", "unauthorized")), 
          :type => "error" 
        }
        response_valid?(hash)

      end

    end
  end

  describe "DELETE destroy a user_authentication " do

    context 'success' do
      it "should destroy a specific user_authentication" do
        user = set_token_auth_with_user({ :with_omniauth => true })
        delete :destroy, :id => user.user_authentications.first.id

        user.reload
        user.user_authentications.should be_empty

        hash = {
          :body => response.body, 
          :status => 200, 
          :message => eql(m("user_authentication.facebook", "destroy")), 
          :type => "success" 
        }
        response_valid?(hash)

      end
    end

    context 'fail' do
    
      it "should not destroy authentication if not logged in" do
        user = FactoryGirl.create(:user, :with_omniauth)
        delete :destroy, :id => user.user_authentications.first.id

        hash = {
          :body => response.body, 
          :status => 401, 
          :message => match(m("user", "unauthorized")), 
          :type => "error" 
        }
        response_valid?(hash)

      end
    end
  end

end
