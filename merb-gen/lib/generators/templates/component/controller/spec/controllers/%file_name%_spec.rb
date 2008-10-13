require File.join(File.dirname(__FILE__), <%= go_up(modules.size + 1) %>, 'spec_helper.rb')

describe <%= full_class_name %>, "index action" do
  before(:each) do
    dispatch_to(<%= full_class_name %>, :index)
  end
end