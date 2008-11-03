require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Testing, "index action" do
  before(:each) do
    dispatch_to(Testing, :index)
  end
end