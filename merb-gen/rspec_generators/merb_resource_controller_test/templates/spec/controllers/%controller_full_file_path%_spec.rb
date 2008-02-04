require File.join(File.dirname(__FILE__), "<%= Array.new((controller_modules.size + 1),'..').join("/") %>", 'spec_helper.rb')

describe <%= full_controller_const %>, "index action" do
  before(:each) do
    @controller = <%= full_controller_const %>.build(fake_request)
    @controller.dispatch('index')
  end
end