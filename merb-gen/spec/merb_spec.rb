require File.dirname(__FILE__) + '/spec_helper'

describe Merb::Generators::MerbGenerator do
      
  it "should invoke the full generator by default" do
    @generator = Merb::Generators::MerbGenerator.new('/tmp', {}, 'testing')
    @generator.should invoke(Merb::Generators::MerbFullGenerator).with('testing')
  end
  
  it "should invoke the flat generator if flat is true" do
    @generator = Merb::Generators::MerbGenerator.new('/tmp', { :flat => true }, 'testing')
    @generator.should invoke(Merb::Generators::MerbFlatGenerator).with('testing')
  end
  
  it "should invoke the very flat generator if very flat is true" do
    @generator = Merb::Generators::MerbGenerator.new('/tmp', { :very_flat => true }, 'testing')
    @generator.should invoke(Merb::Generators::MerbVeryFlatGenerator).with('testing')
  end
  
end