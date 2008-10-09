require File.join(File.dirname(__FILE__), "..", 'spec_helper.rb')

describe "Authentication.customizations" do
  
  before(:each) do
    Authentication.default_customizations.clear
  end
  
  it "should allow addition to the customizations" do
    Authentication.customize_default { "ONE" }
    Authentication.default_customizations.first.call.should == "ONE"
  end
  
  it "should allow multiple additions to the customizations" do
    Authentication.customize_default {"ONE"}
    Authentication.customize_default {"TWO"}
    
    Authentication.default_customizations.first.call.should == "ONE"
    Authentication.default_customizations.last.call.should  == "TWO"
  end
  
end