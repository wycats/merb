require File.dirname(__FILE__) + '/spec_helper'

describe Merb::Generators::FreezerGenerator do

  before(:each) do
    @generator = Merb::Generators::FreezerGenerator.new('/tmp', {})
  end
  
  it "should create a freezing script" do
    @generator.should create('/tmp/script/frozen_merb')
  end
  
  it "should render templates successfully" do
    lambda { @generator.render! }.should_not raise_error
  end
  
end