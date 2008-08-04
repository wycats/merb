require File.dirname(__FILE__) + '/spec_helper'

describe Merb::Generators::ControllerGenerator do

  before(:each) do
    @generator = Merb::Generators::ControllerGenerator.new('/tmp', {}, 'Stuff')
  end
  
  it_should_behave_like "chunky generator"
  
  it "should create a controller" do
    @generator.should create('/tmp/app/controllers/stuff.rb')
  end
  
  it "should create a view" do
    @generator.should create('/tmp/app/views/stuff/index.html.erb')
  end
  
  it "should create a helper" do
    @generator.should create('/tmp/app/helpers/stuff_helper.rb')
  end
  
  describe "with rspec" do
    
    it "should create a controller spec" do
      @generator.should create('/tmp/spec/controllers/stuff_spec.rb')
    end

    it "should create a helper spec" do
      @generator.should create('/tmp/spec/helpers/stuff_helper_spec.rb')
    end
    
  end
  
  describe "with test_unit" do
    
    it "should create a controller test" do
      @generator = Merb::Generators::ControllerGenerator.new('/tmp', { :testing_framework => :test_unit }, 'Stuff')
      @generator.should create('/tmp/test/controllers/stuff_test.rb')
    end
    
  end
  
  describe "with a namespace" do
    
    before(:each) do
      @generator = Merb::Generators::ControllerGenerator.new('/tmp', {}, 'John::Monkey::Stuff')
    end
    
    it "should create a controller" do
      @generator.should create('/tmp/app/controllers/john/monkey/stuff.rb')
    end
    
    it "should create a view" do
      @generator.should create('/tmp/app/views/john/monkey/stuff/index.html.erb')
    end

    it "should create a helper" do
      @generator.should create('/tmp/app/helpers/john/monkey/stuff_helper.rb')
    end

    describe "with rspec" do

      it "should create a controller spec" do
        @generator.should create('/tmp/spec/controllers/john/monkey/stuff_spec.rb')
      end

      it "should create a helper spec" do
        @generator.should create('/tmp/spec/helpers/john/monkey/stuff_helper_spec.rb')
      end

    end

    describe "with test_unit" do

      it "should create a controller test" do
        @generator = Merb::Generators::ControllerGenerator.new('/tmp', { :testing_framework => :test_unit }, 'John::Monkey::Stuff')
        @generator.should create('/tmp/test/controllers/john/monkey/stuff_test.rb')
      end

    end
  end
  
end