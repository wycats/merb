require File.dirname(__FILE__) + '/spec_helper'

describe Merb::Generators::HelperGenerator do

  before(:each) do
    @generator = Merb::Generators::HelperGenerator.new('/tmp', {}, 'Stuff')
  end
  
  it_should_behave_like "namespaced generator"
  
  it "should create a helper" do
    @generator.should create('/tmp/app/helpers/stuff_helper.rb')
  end
  
  describe "with rspec" do
    
    it "should create a helper spec" do
      @generator.should create('/tmp/spec/helpers/stuff_helper_spec.rb')
    end
    
  end
  
  describe "with a namespace" do
    
    before(:each) do
      @generator = Merb::Generators::HelperGenerator.new('/tmp', {}, 'John::Monkey::Stuff')
    end
    
    it "should create a helper" do
      @generator.should create('/tmp/app/helpers/john/monkey/stuff_helper.rb')
    end

    describe "with rspec" do

      it "should create a helper spec" do
        @generator.should create('/tmp/spec/helpers/john/monkey/stuff_helper_spec.rb')
      end

    end

  end
  
end