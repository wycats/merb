require File.join(File.dirname(__FILE__), "spec_helper")

describe "using dependency to update the version of a previously required dependency" do
  before(:all) do
    Gem.use_paths(File.dirname(__FILE__) / "fixtures" / "gems")
    dependency "simple_gem", "= 0.0.1"
    dependency "simple_gem", "= 0.0.2"
  end
  
  it "doesn't load it right away" do
    defined?(Merb::SpecFixture::SimpleGem).should be_nil
    defined?(Merb::SpecFixture::SimpleGem2).should be_nil
  end
  
  it "loads the second one when merb starts" do
    startup_merb
    defined?(Merb::SpecFixture::SimpleGem).should be_nil
    defined?(Merb::SpecFixture::SimpleGem2).should_not be_nil    
  end
end