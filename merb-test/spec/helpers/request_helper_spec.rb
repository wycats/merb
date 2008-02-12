require File.dirname(__FILE__) + '/../spec_helper'

class TestController < Merb::AbstractController
  def index; end
end

class HelperTarget
  include Merb::Test::RequestHelper
end

describe Merb::Test::RequestHelper do
  
  before(:each) do
    @target = HelperTarget.new
  end
  
  describe "#get" do
    it "should call the action via #dispatch_to" do
      @target.should_receive(:dispatch_to)
      @target.get(TestController, :index)
    end
    
    it "should set the request method environmental variable to GET" do
      @target.should_receive(:fake_request).and_return do |env|
        env[:request_method].should == 'GET'
      end
      
      @target.get(TestController, :index)
    end
  end
  
  describe "#post" do
    it "should call the action via #dispatch_to" do
      @target.should_receive(:dispatch_to)
      @target.post(TestController, :index)
    end
    
    it "should set the request method environmental variable to POST" do
      @target.should_receive(:fake_request).and_return do |env|
        env[:request_method].should == 'POST'
      end
      
      @target.post(TestController, :index)
    end
  end
  
  describe "#put" do
    it "should call the action via #dispatch_to" do
      @target.should_receive(:dispatch_to)
      @target.put(TestController, :index)
    end
    
    it "should set the request method environmental variable to PUT" do
      @target.should_receive(:fake_request).and_return do |env|
        env[:request_method].should == 'PUT'
      end
      
      @target.put(TestController, :index)
    end
  end
  
  describe "#head" do
    it "should call the action via #dispatch_to" do
      @target.should_receive(:dispatch_to)
      @target.put(TestController, :index)
    end
    
    it "should set the request method environmental variable to HEAD" do
      @target.should_receive(:fake_request).and_return do |env|
        env[:request_method].should == 'HEAD'
      end
      
      @target.head(TestController, :index)
    end
  end
  
  describe "#delete" do
    it "should call the action via #dispatch_to" do
      @target.should_receive(:dispatch_to)
      @target.put(TestController, :index)
    end
    
    it "should set the request method environmental variable to DELETE" do
      @target.should_receive(:fake_request).and_return do |env|
        env[:request_method].should == 'DELETE'
      end
      
      @target.delete(TestController, :index)
    end
  end
  
  describe "#mulitpart_post" do
    it "should set the request method environmental variable to POST" do
      @target.should_receive(:fake_request).and_return do |(env, params)|
        env[:request_method].should == 'POST'
      end
      
      @target.multipart_post(TestController, :index, :foo => :bar)
    end
    
    it "should set the post body parameter variable" do
      @target.should_receive(:fake_request).and_return do |(env, params)|
        params.should have_key(:post_body)
      end
      
      @target.multipart_post(TestController, :index, :foo => :bar)
    end
    
    it "should set the content type and length environmental variables" do
      @target.should_receive(:fake_request).and_return do |(env, params)|
        env.should have_key(:content_type)
        env.should have_key(:content_length)
      end
      
      @target.multipart_post(TestController, :index, :foo => :bar)
    end
  end
  
  describe "#mulitpart_put" do
    it "should set the request method environmental variable to PUT" do
      @target.should_receive(:fake_request).and_return do |(env, params)|
        env[:request_method].should == 'PUT'
      end
      
      @target.multipart_put(TestController, :index, :foo => :bar)
    end
  end
end