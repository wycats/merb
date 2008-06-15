require File.dirname(__FILE__) + '/spec_helper'

describe Merb::ComponentGenerators::ModelGenerator do
  
  it "should render" do
    @generator = Merb::ComponentGenerators::ControllerGenerator.new('/tmp', {}, 'Stuff')
    p @generator.templates[0].render
  end
  
end