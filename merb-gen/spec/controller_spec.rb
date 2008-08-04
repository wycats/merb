require File.dirname(__FILE__) + '/spec_helper'

describe Merb::Generators::ControllerGenerator do

  before(:each) do
    @generator = Merb::Generators::ControllerGenerator.new('/tmp', {}, 'Stuff')
  end
  
  it_should_behave_like "chunky generator"
  
end