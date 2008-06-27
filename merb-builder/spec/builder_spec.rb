require File.dirname(__FILE__) + '/spec_helper'

describe "Builder" do
  before(:each) do
    @xml = ::Builder::XmlMarkup.new :indent => 2
    @xml.instruct!
  end
  
  it "should be able to render Builder templates" do
    c = dispatch_to(BuilderController, :index, :format => "xml")
    @xml.hello "World"
    c.body.should == @xml.target!
  end
  
  it "should be able to render partial Builder templates" do
    c = dispatch_to(PartialBuilder, :index, :format => "xml")
    @xml.hello "World"
    c.body.should == @xml.target!
  end
  
  it "should be able to have ivars defined in both the controller and the parent template" do
    c = dispatch_to(PartialIvars, :index, :format => "xml")
    @xml.p "Partial Builder"
    c.body.should == @xml.target!
  end
  
  it "should use the builder configuration in Merb::Config" do
    c = dispatch_to(BuilderConfig, :index, :format => "xml")
    xml = ::Builder::XmlMarkup.new :indent => 4
    xml.instruct!
    xml.foo do
      xml.bar "baz"
    end
    c.body.should == xml.target!
  end
  
  it "should capture_builder properly" do
    c = dispatch_to(CaptureBuilder, :index, :format => "xml")
    xml = ::Builder::XmlMarkup.new :indent => 4
    xml.instruct!
    xml.comment! "I would not say such things if I were you"
    xml.node 'Capture'
    
    c.body.should == xml.target!
  end
  
  it "should concat_builder properly" do
    c = dispatch_to(ConcatBuilder, :index, :format => "xml")
    xml = ::Builder::XmlMarkup.new :indent => 4
    xml.instruct!
    xml.node 'Concat'
    
    c.body.should == xml.target!.chomp
  end
  
end
