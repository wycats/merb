require "#{File.dirname(__FILE__)}/spec_helper"

describe "With the identity map enabled" do
  before(:each) do
    @response = request('/id_map/')
  end
  it "/id_map returns 'true'" do
    @response.should have_body('true')
  end
end
