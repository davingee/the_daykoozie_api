require 'spec_helper'
describe Api::V1::CalendarsController do

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
      
        it "should show all calendars" do
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
      
        it "should show all calendars" do
          FactoryGirl.create(:calendar)
          FactoryGirl.create(:calendar)
          FactoryGirl.create(:calendar)
          get :index, :format => :json
          hash = { :body => response.body, :status => 200, 
            :type => "success", 
            :root => "calendars", 
            :models => Calendar.all }
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
          calendar = FactoryGirl.create(:calendar)
          get :show, :id => calendar.id, :format => :json

          hash = { :body => response.body, :status => 200, 
            :type => "success", :root => "calendar", :model => calendar,
            :model_type => :attributes, :attributes => { :id => calendar.id, :user_id => calendar.user.id } }
          response_valid?(hash)
        end
        
        it "should  show a calendar that is a secret if i have permisions" do
          calendar = FactoryGirl.create(:calendar, :secret => true)
          user = set_token_auth_with_user(:with_user => calendar.user)
          get :show, :id => calendar.id, :format => :json
          hash = { :body => response.body, :status => 200, 
            :type => "success", :root => "calendar", :model => calendar,
            :model_type => :attributes, :attributes => { :id => calendar.id, :user_id => user.id } }
          response_valid?(hash)

        end

      end

    end

    context 'not authenticated' do

      context 'success' do
      
        it "should show specific calendars except soft_deleted" do
          calendar = FactoryGirl.create(:calendar)
          user = calendar.user
          get :show, :id => calendar.id, :format => :json
          hash = { :body => response.body, :status => 200, 
            :type => "success", :root => "calendar", :model => calendar,
            :model_type => :attributes, :attributes => { :id => calendar.id, :user_id => user.id } }
          response_valid?(hash)
        end
      
      end

      context 'failure' do
        it "should not show a calendar that cannot be found" do
          calendar = FactoryGirl.create(:calendar)
          get :show, :id => 44, :format => :json
          hash = { :body => response.body, :status => 404, 
            :type => "error", :root => false, :message => match(m("rescue", "RecordNotFound")) }
          response_valid?(hash)

        end

        it "should not show a calendar that is a secret" do
          calendar = FactoryGirl.create(:calendar, :secret => true)
          get :show, :id => calendar.id, :format => :json
          hash = { :body => response.body, :status => 401, 
            :type => "error", :root => false, :message => match(m("calendar", "unauthorized")) }
          response_valid?(hash)

        end

      end

    end

  end
  
  describe "POST to create a calendar" do

    context 'success' do

      it "should create a calendar" do
        user = set_token_auth_with_user
        post :create, :calendar => calendar_params, :format => :json 
        hash = { :body => response.body, :status => 200, 
          :type => "success", :root => "calendar", :model => user,
          :message => eql( m("calendar", "create")),
          :model_type => :attributes, :attributes => { :id => Calendar.first.id, :user_id => user.id, :description => calendar_params[:description] } }
        response_valid?(hash)
      end

    end

    context 'failure' do
      
      it "should show validations if calendar doesn't have all fields right" do
        user = set_token_auth_with_user
        post :create, :calendar => calendar_params.merge(:title => ''), :format => :json
        hash = { :body => response.body, :status => 409, 
          :type => "error", :root => "calendar", 
          :message => eql(JSON.parse(Calendar.create(calendar_params.merge(:title => '')).errors.to_json)),
          :model_type => :attributes, :attributes => { :id => nil, :title => '', :description => calendar_params[:description] } }
        response_valid?(hash)

      end

      it "should return 401 if no basic auth exists or is correct" do
        post :create, :calendar => calendar_params, :format => :json
        hash = { :body => response.body, :status => 401, 
          :type => "error", :root => false,
          :message => match(m("user", "unauthorized")) }
        response_valid?(hash)
      end

    end

  end

  describe "GET to edit a calendar" do

    context 'success' do
      it "should return calendar data if logged in" do

        calendar = FactoryGirl.create(:calendar, :secret => true)
        user = set_token_auth_with_user(:with_user => calendar.user)
        get :edit, :id => calendar.id, :format => :json

        hash = { :body => response.body, :status => 200, 
          :type => "success", :root => "calendar", :model => calendar,
          :model_type => :attributes, :attributes => { :id => calendar.id, :user_id => user.id } }
          response_valid?(hash)
      end
    end
    
    context 'error' do
      it "should return 401 if user not logged in" do
        calendar = FactoryGirl.create(:calendar)
        get :edit, :id => calendar.id, :format => :json
        hash = { :body => response.body, :status => 401, 
          :message => match(m("user", "unauthorized")), :type => "error", 
          :root => false }
        response_valid?(hash)

      end
    end
  end

  describe "Put to update a user" do

    context 'success' do
      it "should return calendar with updated attributes to the logged in user" do
        calendar = FactoryGirl.create(:calendar, :secret => true)
        user = set_token_auth_with_user(:with_user => calendar.user)
        get :update, :id => calendar.id, :calendar => {:title => "testing"}, :format => :json

        hash = { :body => response.body, :status => 200, 
          :type => "success", :root => "calendar",  :model => calendar, 
          :message => eql(m("calendar", "update")),
          :model_type => :attributes, :attributes => { :id => user.id, :title => 'testing' } }
        response_valid?(hash)
        
      end
    end

    context 'error' do

      it "should return validation errors if any" do
        calendar = FactoryGirl.create(:calendar)
        user = set_token_auth_with_user(:with_user => calendar.user)
        get :update, :id => calendar.id, :calendar => {:title => ""}, :format => :json
        hash = { :body => response.body, :status => 409, 
          :type => "error", :root => "calendar",
          :message => eql(JSON.parse(Calendar.create(calendar_params.merge(:title => "")).errors.to_json)) }
        response_valid?(hash)
      end

      it "should return 401 if no permisions" do
        calendar = FactoryGirl.create(:calendar)
        user = set_token_auth_with_user
        
        get :update, :id => calendar.id, :calendar => {:title => ""}, :format => :json
        hash = { :body => response.body, :status => 401, 
          :type => "error", :root => false,
          :message => match(m("calendar", "unauthorized")) }
        response_valid?(hash)

      end

      it "should return 401 unauthorized if user not logged in" do
        calendar = FactoryGirl.create(:calendar, :secret => true)
        get :update, :id => calendar.id, :calendar => {:title => ""}, :format => :json
        hash = { :body => response.body, :status => 401, 
          :type => "error", :root => false,
          :message => match(m("user", "unauthorized")) }
        response_valid?(hash)

      end
    end

  end

  describe "Delete to  delete a calendar" do

    context 'success' do
      it "should destroy the calendar" do
        calendar = FactoryGirl.create(:calendar)
        user = set_token_auth_with_user(:with_user => calendar.user)
        delete :destroy, :id => calendar.id, :format => :json
        hash = { :body => response.body, :status => 200, 
          :type => "success", :root => false,
          :message => eql(m("calendar", "destroy")) }
        response_valid?(hash)
      end
    end

    context 'failure' do
      
      it 'should not destroy if no current_user' do
        calendar = FactoryGirl.create(:calendar)
        delete :destroy, :id => calendar.id, :format => :json
        hash = { :body => response.body, :status => 401, 
          :type => "error", :root => false,
          :message => eql(m("user", "unauthorized")) }
        response_valid?(hash)
      end

      it 'should not destroy if current_user does not have permaisions' do
        calendar = FactoryGirl.create(:calendar)
        user = set_token_auth_with_user
        delete :destroy, :id => calendar.id, :format => :json
        hash = { :body => response.body, :status => 401, 
          :type => "error", :root => false,
          :message => match(m("calendar", "unauthorized")) }
        response_valid?(hash)
      end


    end

  end

end
