require File.dirname(__FILE__) + '/spec_helper'

describe Merb::Generators::PartControllerGenerator do

  before(:each) do
    @generator = Merb::Generators::PartControllerGenerator.new('/tmp', {}, 'Stuff')
  end
  
  it_should_behave_like "namespaced generator"
  
  it "should create a controller" do
    @generator.should create('/tmp/app/parts/stuff_part.rb')
  end
  
  it "should create a view" do
    @generator.should create('/tmp/app/parts/views/stuff_part/index.html.erb')
  end
  
  it "should create a helper" do
    @generator.should create('/tmp/app/helpers/stuff_part_helper.rb')
  end
  
  describe "with rspec" do
    
    it "should create a controller spec"

    it "should create a helper spec" do
      @generator.should create('/tmp/spec/helpers/stuff_part_helper_spec.rb')
    end
    
  end
  
  describe "with test_unit" do
    
    it "should create a controller test"
    
  end
  
  describe "with a namespace" do
    
    before(:each) do
      @generator = Merb::Generators::PartControllerGenerator.new('/tmp', {}, 'John::Monkey::Stuff')
    end
    
    it "should create a controller" do
      @generator.should create('/tmp/app/parts/john/monkey/stuff_part.rb')
    end

    it "should create a view" do
      @generator.should create('/tmp/app/parts/views/john/monkey/stuff_part/index.html.erb')
    end

    it "should create a helper" do
      @generator.should create('/tmp/app/helpers/john/monkey/stuff_part_helper.rb')
    end

    describe "with rspec" do

      it "should create a controller spec"

      it "should create a helper spec" do
        @generator.should create('/tmp/spec/helpers/john/monkey/stuff_part_helper_spec.rb')
      end

    end

    describe "with test_unit" do

      it "should create a controller test"

    end
  end
  
end