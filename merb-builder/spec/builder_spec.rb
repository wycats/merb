require File.dirname(__FILE__) + '/spec_helper'

describe "Builder" do
  before(:each) do
    @xml = ::Builder::XmlMarkup.new :indent => 2
    @xml.instruct! :xml, :version => "1.0", :encoding => "UTF-8"
  end
  
  it "should be able to render Builder templates" do
    c = dispatch_to(BuilderController, :index, :format => "xml")
    @xml.hello "World"
    c.body.should == @xml.target!
  end
end
