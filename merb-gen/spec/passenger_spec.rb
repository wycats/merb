require File.dirname(__FILE__) + '/spec_helper'

describe Merb::Generators::PassengerGenerator do
  
  describe "templates" do
    before(:each) do
      @generator = Merb::Generators::PassengerGenerator.new('/tmp', {})
    end

    it "should create a config.ru file" do
      @generator.should create('/tmp/config.ru')
    end
    
    it "should render templates successfully" do
      lambda { @generator.render! }.should_not raise_error
    end
    
  end
  
end
