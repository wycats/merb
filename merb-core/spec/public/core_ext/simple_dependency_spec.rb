require File.join(File.dirname(__FILE__), "spec_helper")

describe "using dependency to require a simple gem" do
  before(:all) do
    Gem.use_paths(File.dirname(__FILE__) / "fixtures" / "gems")
    dependency "simple_gem"
  end
  
  it "doesn't load it right away" do
    defined?(Merb::SpecFixture::SimpleGem2).should be_nil
  end
  
  it "loads it when merb starts" do
    startup_merb
    defined?(Merb::SpecFixture::SimpleGem2).should_not be_nil
  end
end