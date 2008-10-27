require File.join(File.dirname(__FILE__), "spec_helper")

describe "using dependency to require a bad gem" do
  before(:all) do
    Gem.use_paths(File.dirname(__FILE__) / "fixtures" / "gems")
    dependency "bad_require_gem", :require_as => "BadRequireGem"
  end
  
  it "doesn't load it right away" do
    defined?(Merb::SpecFixture::BadRequireGem).should be_nil
  end
  
  it "loads the file once Merb is started" do
    startup_merb
    defined?(Merb::SpecFixture::BadRequireGem).should_not be_nil
  end
end