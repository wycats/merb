require File.dirname(__FILE__) + '/spec_helper'

describe Merb::Generators::MerbGenerator do
  
  describe "templates" do
    
    before do
      @generator = Merb::Generators::MerbGenerator.new('/tmp', {}, 'testing')
    end
    
    it "should have an init.rb" do
      template = @generator.template(:config_init_rb)
      template.destination.should == '/tmp/testing/config/init.rb'
    end
    
    it "should have an application controller" do
      template = @generator.template(:app_controllers_application_rb)
      template.destination.should == '/tmp/testing/app/controllers/application.rb'
    end
    
    it "should have an exceptions controller" do
      template = @generator.template(:app_controllers_exceptions_rb)
      template.destination.should == '/tmp/testing/app/controllers/exceptions.rb'
    end
    
  end
  
end