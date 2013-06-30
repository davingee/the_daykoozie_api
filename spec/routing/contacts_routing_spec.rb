require "spec_helper"

describe ContactsController do
  describe "routing" do

    it "routes to #new" do
      expect(:get => "/contacts/new.json").to route_to(
        :controller => "contacts",
        :action => "new",
        :format => "json"
      )
    end

    it "routes to #create" do
      expect(:post => "/contacts.json").to route_to(
        :controller => "contacts",
        :action => "create",
        :format => "json"
      )
    end

    it "does not route to other formats other then :json" do
      post("/contacts").should_not route_to(
        :controller => "contacts",
        :action => "create",
        :format => "html"
      )
    end

  end

end
