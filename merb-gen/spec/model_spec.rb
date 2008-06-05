require File.dirname(__FILE__) + '/spec_helper'

describe Merb::ComponentGenerators::ModelGenerator do
  
  it "should complain if no name is specified" do
    lambda {
      @generator = Merb::ComponentGenerators::ModelGenerator.new('/tmp', {})
    }.should raise_error(::Templater::TooFewArgumentsError)
  end
  
  it "should default to the rspec testing framework" do
    @generator = Merb::ComponentGenerators::ModelGenerator.new('/tmp', {}, 'User')
    @generator.testing_framework.should == :spec
  end
  
  it "should have the model and spec templates by default" do
    @generator = Merb::ComponentGenerators::ModelGenerator.new('/tmp', {}, 'User')
    @generator.templates.map{|t| t.name}.should == [:model, :spec]
  end
  
  it "should have the model and test_unit templates if test_unit is specified as testing framework" do
    @generator = Merb::ComponentGenerators::ModelGenerator.new('/tmp', { :testing_framework => :test_unit }, 'User')
    @generator.templates.map{|t| t.name}.should == [:model, :test_unit]
  end
  
  it "should have the model and spec templates if spec is specified as testing framework" do
    @generator = Merb::ComponentGenerators::ModelGenerator.new('/tmp', { :testing_framework => :spec }, 'User')
    @generator.templates.map{|t| t.name}.should == [:model, :spec]
  end
  
end

describe Merb::ComponentGenerators::ModelGenerator, '#file_name' do
  
  it "should convert the name to snake case" do
    @generator = Merb::ComponentGenerators::ModelGenerator.new('/tmp', {}, 'SomeMoreStuff')
    @generator.file_name.should == 'some_more_stuff'
  end
  
end

describe Merb::ComponentGenerators::ModelGenerator, '#class_name' do
  
  it "should convert the name to camel case" do
    @generator = Merb::ComponentGenerators::ModelGenerator.new('/tmp', {}, 'some_more_stuff')
    @generator.class_name.should == 'SomeMoreStuff'
  end
  
end