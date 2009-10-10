require File.expand_path(File.join(File.dirname(__FILE__), "spec_helper"))

startup_merb(
  :merb_root => File.dirname(__FILE__) / "test_app",
  :gemfile   => File.dirname(__FILE__) / "test_app" / "Gemfile",
  :fork_for_class_load => false
)
Merb::Config[:log_stream] = File.open("/dev/null", "w")
Merb.reset_logger!

describe "an app tested using the webrat proxies" do
  describe("#visit") do
    it "supports visit" do
      visit("/testing")
    end
  
    it "can use the Merb expectations with visit" do
      visit("/testing").should be_successful
    end
  
    it "supports visit intermixed with request" do
      resp = visit("/testing/next")
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
  
  describe "runs through defined Rack middle ware" do
    it "returns the response in the rack middleware" do
      resp = visit "/dummy"
      resp.body.to_s.should == "This is a dummy content"
    end
  end
  
end
