require File.dirname(__FILE__) + "/spec_helper"
#require 'merb-core/dispatch/session/store_container'
#require File.join( File.dirname(__FILE__), "..", "lib", 'merb', 'session', 'sequel_session')

describe Merb::DataMapperSession do

  before(:each) do
    @session_class = Merb::DataMapperSession
    @session = @session_class.generate
  end

  it "should have a session_store_type class attribute" do
    @session.class.session_store_type.should == :datamapper
  end

  it "should persist values" do
    response = request('/session/set')
    response.should be_successful
    response.body.should == 'value'
    response = request('/session/get')
    response.should be_successful
    response.body.should == 'value'
  end
end
