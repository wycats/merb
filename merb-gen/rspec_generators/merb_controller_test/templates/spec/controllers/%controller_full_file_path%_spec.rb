require File.join(File.dirname(__FILE__), "<%= Array.new((controller_modules.size + 1),'..').join("/") %>", 'spec_helper.rb')

describe <%= full_controller_const %>, "index action" do
  before(:each) do
    dispatch_to(<%= full_controller_const %>, :index)
  end
end