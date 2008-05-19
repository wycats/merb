require File.dirname(__FILE__) + '/spec_helper'

describe Merb::AbstractController do
  
  it "should be able to accept Action Arguments" do
    dispatch_to(ActionArgs, :index, :foo => "bar").body.should == "bar"
  end
  
  it "should be able to accept multiple Action Arguments" do
    dispatch_to(ActionArgs, :multi, :foo => "bar", :bar => "baz").body.should == "bar baz"    
  end
  
  it "should be able to handle defaults in Action Arguments" do
    dispatch_to(ActionArgs, :defaults, :foo => "bar").body.should == "bar bar"
  end
  
  it "should be able to handle out of order defaults" do
    dispatch_to(ActionArgs, :defaults_mixed, :foo => "bar", :baz => "bar").body.should == "bar bar bar"    
  end
  
  it "should throw a BadRequest if the arguments are not provided" do
    lambda { dispatch_to(ActionArgs, :index) }.should raise_error(Merb::ControllerExceptions::BadRequest)
  end
  
  it "should treat define_method actions as equal" do
    dispatch_to(ActionArgs, :dynamic_define_method).body.should == "mos def"
  end
  
  it "should be able to inherit actions for use with Action Arguments" do
    dispatch_to(ActionArgs, :funky_inherited_method, :foo => "bar", :bar => "baz").body.should == "bar baz"
  end
  
  it "should be able to handle nil defaults" do
    dispatch_to(ActionArgs, :with_default_nil, :foo => "bar").body.should == "bar "
  end
  
end