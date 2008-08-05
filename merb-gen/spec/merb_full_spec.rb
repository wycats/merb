require File.dirname(__FILE__) + '/spec_helper'

describe Merb::Generators::MerbFullGenerator do
  
  describe "templates" do
    
    before do
      @generator = Merb::Generators::MerbFullGenerator.new('/tmp', {}, 'testing')
    end
    
    it "should create an init.rb" do
      @generator.should create('/tmp/testing/config/init.rb')
    end
    
    it "should have an application controller" do
      @generator.should create('/tmp/testing/app/controllers/application.rb')
    end
    
    it "should have an exceptions controller" do
      @generator.should create('/tmp/testing/app/controllers/exceptions.rb')
    end
    
    it "should create a number of views"
    
    it "should render templates successfully" do
      lambda { @generator.render! }.should_not raise_error
    end
    
  end
  
end