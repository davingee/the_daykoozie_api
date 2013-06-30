require 'spec_helper'

describe "Errors" do
  describe "routing error should respond with a :not_found or 404" do
    it "" do
      visit "/foo_bar"
      page.status_code.should == 400
      body = JSON.parse(page.body)
      body["message"]["content"].should =~ /#{(I18n.translate "failure.RoutingError")}/
      body["message"]["type"].should == "error"
    end

  end
end
