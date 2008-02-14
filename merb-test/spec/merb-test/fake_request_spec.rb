require File.dirname(__FILE__) + '/../spec_helper'

describe Merb::Test::FakeRequest, ".new(env = {}, req = StringIO.new)" do
  it "should create request with default enviroment, minus rack.input" do
    @mock = Merb::Test::FakeRequest.new
    @mock.env.except('rack.input').should == Merb::Test::FakeRequest::DEFAULT_ENV
  end
 
  it "should override default env values passed in HTTP format" do
    @mock = Merb::Test::FakeRequest.new('HTTP_ACCEPT' => 'nothing')
    @mock.env['HTTP_ACCEPT'].should == 'nothing'
  end
 
  it "should override default env values passed in symbol format" do
    @mock = Merb::Test::FakeRequest.new(:http_accept => 'nothing')
    @mock.env['HTTP_ACCEPT'].should == 'nothing'
  end
  
  it "should set rack input to an empty StringIO" do
    @mock = Merb::Test::FakeRequest.new
    @mock.env['rack.input'].should be_kind_of(StringIO)
    @mock.env['rack.input'].read.should == ''
  end
end