require File.dirname(__FILE__) + '/spec_helper'

describe Merb::Generators::FcgiGenerator do
  
  describe "templates" do
    before(:each) do
      @generator = Merb::Generators::FcgiGenerator.new('/tmp', {})
    end

    it "should create a .htaccess file within public/" do
      @generator.should create('/tmp/public/.htaccess')
    end

    it "should create a merb.fcgi file within public/" do
      @generator.should create('/tmp/public/.htaccess')
    end
    
    it "should render templates successfully" do
      lambda { @generator.render! }.should_not raise_error
    end
    
  end
  
end
