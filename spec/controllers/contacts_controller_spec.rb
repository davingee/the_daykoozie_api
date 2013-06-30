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

  describe "POST to create a contact" do

    context 'success' do

      it "if current_user it should create a contact with user id" do
        user = set_token_auth_with_user
        post :create, :contact => contact_params, :format => :json
        hash = { :body => response.body, :status => 200, 
          :message => eql(m("contact", "create")), 
          :type => "success", 
          :root => "contact",
          :model_type => :attributes, :attributes => {:name => "foo", :user_id => user.id} }
        response_valid?(hash)
      end

      it "if not current_user it should create a contact without user id" do
        set_basic_auth
        post :create, :contact => contact_params, :format => :json
        hash = { :body => response.body, :status => 200, 
          :message => eql(m("contact", "create")), 
          :type => "success", 
          :root => "contact",
          :model_type => :attributes, :attributes => {:name => "foo", :user_id => nil} }
        response_valid?(hash)

      end

    end

    context 'failure' do

      it "should show errors of validations with a 406" do
        set_basic_auth
        post :create, :contact => contact_params.merge(:subject => ""), :format => :json
        hash = { :body => response.body, :status => 409, 
          :message => eql(JSON.parse(Contact.create(contact_params.merge(:subject => "")).errors.to_json)), 
          :type => "error", 
          :root => "contact",
          :model_type => :attributes, :attributes => {:name => "foo", :email => "foo@bar.com"} }
        response_valid?(hash)
      end

      it "should return 401 if not authorized" do
        user = FactoryGirl.create(:user)
        post :create, :contact => contact_params, :format => :json
        hash = { :body => response.body, :status => 401, 
          :message => match(m("user", "unauthorized")), 
          :type => "error", 
          :root => false }
        response_valid?(hash)

      end

    end

  end

  describe "GET new to pull data if current_user" do

    context 'success' do
      it "should create a contact instance filled in with current_user" do
        user = set_token_auth_with_user(:with_omniauth => true)
        get :new, :format => :json
        hash = { :body => response.body, :status => 200, 
          :type => "success", :root => "contact",
          :model_type => :attributes, :attributes => { :name => user.name, :email => user.email, :content => nil, :user_id => user.id } }
        response_valid?(hash)

      end

      it "if create a contact instance with no user data if no current_user" do
        set_basic_auth
        get :new, :format => :json
        hash = { :body => response.body, :status => 200, 
          :type => "success", :root => "contact",
          :model_type => :attributes, :attributes => { :name =>  nil, :email => nil, :content => nil, :user_id => nil } }
        response_valid?(hash)

      end

    end
    context 'fail' do
      it "should return 401 if not authorized" do
        get :new, :format => :json

        hash = { :body => response.body, :status => 401, 
          :message => match(m("user", "unauthorized")),
          :type => "error", 
          :root => false }
        response_valid?(hash)
      end
    end
  end
  
end
