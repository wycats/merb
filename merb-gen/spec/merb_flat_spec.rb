require File.dirname(__FILE__) + '/spec_helper'

describe Merb::Generators::MerbFlatGenerator do
  
  describe "templates" do
    
    before do
      @generator = Merb::Generators::MerbFlatGenerator.new('/tmp', {}, 'testing')
    end
    
    it_should_behave_like "named generator"
    it_should_behave_like "app generator"

    it "should create an Gemfile" do
      @generator.should create('/tmp/testing/Gemfile')
    end
    
    it "should create a number of views"
    
    it "should render templates successfully" do
      lambda do
        @generator.render!
      end.should_not raise_error
    end
  end
end
