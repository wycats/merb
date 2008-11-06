require File.join(File.dirname(__FILE__), "spec_helper")

describe "using dependency to require a simple gem" do
  before(:all) do
    Gem.use_paths(File.dirname(__FILE__) / "fixtures" / "gems")
  end
  
  it "loads dependencies immediately if Merb is already started" do
    startup_merb
    dependency "simple_gem"
    defined?(Merb::SpecFixture::SimpleGem2).should_not be_nil
  end
end