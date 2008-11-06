require File.expand_path(File.join(File.dirname(__FILE__), "spec_helper"))

Merb.start(
  :merb_root => File.dirname(__FILE__) / "test_app",
  :fork_for_class_load => false
)
Merb::Config[:log_stream] = File.open("/dev/null", "w")
Merb.reset_logger!

require "webrat"

describe "an app tested with raw webrat" do
  it "supports request" do
    resp = request("/testing")
    resp.should be_successful
  end
  
  it "correctly handles links even if the request " \
     "wasn't originally made by webrat" do
    request("/testing")
    @session.click_link("Next")
    @session.response.should have_xpath("//p[contains(., 'Got to next')]")
  end
  
  describe "with the webrat session" do
    before(:each) do
      @session = Webrat::Session.new
      @session.visits("/testing")      
    end
    
    it "supports Webrat session #visiting" do
      @session.response.should be_successful
    end
    
    it "supports Webrat session #click" do
      @session.click_link("Next")
      @session.response.should have_xpath("//p[contains(., 'Got to next')]")
    end
  end
end

describe "an app tested using the webrat proxies" do
  describe("#visits") do
    it "supports visits" do
      visits("/testing")
    end
  
    it "can use the Merb expectations with visits" do
      visits("/testing").should be_successful
    end
  
    it "supports visits intermixed with request" do
      request("/testing")
      resp = visits("/testing/next")
      resp.should have_xpath("//p")
    end
  end
  
  describe("#click_link") do
    it "supports click_link" do
      visit "/testing"
      click_link "Next"
    end
    
    it "can use the Merb expectations with click_link" do
      visit "/testing"
      resp = click_link "Next"
      resp.should have_xpath("//p[contains(., 'Got to next')]")
    end
    
    it "supports click_link after a request" do
      request("/testing")
      resp = click_link "Next"
      resp.should have_xpath("//p[contains(., 'Got to next')]")
    end
  end
  
  describe "filling in forms" do
    it "lets you fill in text fields" do
      visit "/testing/show_form"
      fill_in "Name", :with => "Merby"
      fill_in "Address", :with => "82 South Park"
      click_button "Submit!"
    end
    
    it "returns the response when you fill in text fields" do
      visit "/testing/show_form"
      fill_in "name", :with => "Merby"
      fill_in "address", :with => "82 South Park"
      resp = click_button "Submit!"
      resp.should have_xpath("//p[contains(., 'Merby')]")
    end
    
    it "lets you check checkboxes" do
      visit "/testing/show_form"
      check "Tis truez"
    end
    
    it "returns the response when you check checkboxes" do
      visit "/testing/show_form"
      check "Tis truez"
      resp = click_button "Submit!"
      resp.should have_xpath("//p[contains(., 'truez: 1')]")
    end
  end
  
end