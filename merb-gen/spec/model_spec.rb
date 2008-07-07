require File.dirname(__FILE__) + '/spec_helper'

describe Merb::Generators::ModelGenerator do
  
  it "should complain if no name is specified" do
    lambda {
      @generator = Merb::Generators::ModelGenerator.new('/tmp', {})
    }.should raise_error(::Templater::TooFewArgumentsError)
  end
  
  it "should default to the rspec testing framework" do
    @generator = Merb::Generators::ModelGenerator.new('/tmp', {}, 'User')
    @generator.testing_framework.should == :rspec
  end
  
  it "should have the model and spec actions by default" do
    pending "this doesn't really work with fs generators"
    @generator = Merb::Generators::ModelGenerator.new('/tmp', {}, 'User')
    @generator.templates.map{|t| t.name}.should == [:model, :spec]
  end
  
  it "should have the model and test_unit templates if test_unit is specified as testing framework" do
    pending "this doesn't really work with fs generators"
    @generator = Merb::Generators::ModelGenerator.new('/tmp', { :testing_framework => :test_unit }, 'User')
    @generator.templates.map{|t| t.name}.should == [:model, :test_unit]
  end
  
  it "should have the model and spec templates if spec is specified as testing framework" do
    pending "this doesn't really work with fs generators"    
    @generator = Merb::Generators::ModelGenerator.new('/tmp', { :testing_framework => :rspec }, 'User')
    @generator.templates.map{|t| t.name}.should == [:model, :spec]
  end
  
end

describe Merb::Generators::ModelGenerator do
  
  before do
    @generator = Merb::Generators::ModelGenerator.new('/tmp', {}, 'SomeMoreStuff')
  end
  
  describe '#file_name' do
  
    it "should convert the name to snake case" do
      @generator.name = 'SomeMoreStuff'
      @generator.file_name.should == 'some_more_stuff'
    end
  
  end

  describe '#class_name' do
  
    it "should convert the name to camel case" do
      @generator.name = 'some_more_stuff'
      @generator.class_name.should == 'SomeMoreStuff'
    end
  
  end
  
  describe '#attributes_for_accessor' do
  
    it "should convert the name to camel case" do
      @generator = Merb::Generators::ModelGenerator.new('/tmp', {}, 'SomeMoreStuff', 'test:object', 'arg:object', 'blah:object')
      @generator.attributes_for_accessor.should == ':arg, :blah, :test'
    end  
  
  end
  
  describe '#invocations' do
  
    before(:each) do
      @generator.attributes = { 'test' => 'string', 'blah' => 'integer' }
      @invocation = @generator.invocations.first
    end
  
    it "should invoke a migration" do
      @invocation.should be_kind_of(Merb::Generators::MigrationGenerator)
    end
    
    it "should have the same name as the model" do
      @invocation.name.should == "SomeMoreStuff"
    end
    
    it "should have the same attributes" do
      @invocation.attributes['test'].should == 'string'
      @invocation.attributes['blah'].should == 'integer'
    end
    
    it "should set the options 'model' to true" do
      @invocation.options[:model].should be_true
    end
  
  end
  
end