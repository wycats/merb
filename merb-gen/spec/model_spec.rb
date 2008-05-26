require File.dirname(__FILE__) + '/spec_helper'

describe Merb::ComponentGenerators::ModelGenerator do
  
  it "should complain if no name is specified" do
    lambda {
      @generator = Merb::ComponentGenerators::ModelGenerator.new('/tmp', {})
    }.should raise_error(::Templater::TooFewArgumentsError)
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