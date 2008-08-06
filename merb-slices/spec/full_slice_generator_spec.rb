require File.dirname(__FILE__) + '/spec_helper'

describe Merb::Generators::FullSliceGenerator do
  
  include Merb::Test::GeneratorHelper
  
  describe "templates" do
    
    before do
      @generator = Merb::Generators::FullSliceGenerator.new('/tmp', {}, 'testing')
    end
    
    it "should create a number of templates"
    
    it "should render templates successfully" do
      lambda { @generator.render! }.should_not raise_error
    end
    
  end
  
end