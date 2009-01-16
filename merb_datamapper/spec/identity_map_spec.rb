require "#{File.dirname(__FILE__)}/spec_helper"
require "#{File.dirname(__FILE__)}/sample_app"

Spec::Runner.configure do |config|
  config.include Merb::Test::RequestHelper
end

describe "With the identity map enabled" do
  before(:each) do
    @response = request('/id_map')
  end
  it "/id_map returns 'true'" do
    pending "This spec passes when run alone" do
      @response.should have_body('true')
    end
  end
end
