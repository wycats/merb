require File.dirname(__FILE__) + '/spec_helper'

describe Merb::Generators::SliceGenerator do
  
  include Merb::Test::GeneratorHelper
  
  it "should invoke the full generator by default" do
    @generator = Merb::Generators::SliceGenerator.new('/tmp', {}, 'testing')
    @generator.should invoke(Merb::Generators::FullSliceGenerator).with('testing')
  end
  
  it "should invoke the flat generator if flat is true" do
    @generator = Merb::Generators::SliceGenerator.new('/tmp', { :thin => true }, 'testing')
    @generator.should invoke(Merb::Generators::ThinSliceGenerator).with('testing')
  end
  
  it "should invoke the very flat generator if very flat is true" do
    @generator = Merb::Generators::SliceGenerator.new('/tmp', { :very_thin => true }, 'testing')
    @generator.should invoke(Merb::Generators::VeryThinSliceGenerator).with('testing')
  end
  
end