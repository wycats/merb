require File.join(File.dirname(__FILE__), "spec_helper")

describe "using depdendency to require a simple gem immediately" do
  before(:all) do
    Gem.use_paths(File.dirname(__FILE__) / "fixtures" / "gems")
    dependency "simple_gem", :immediate => true
  end
  
  it "loads it right away" do
    defined?(Merb::SpecFixture::SimpleGem2).should_not be_nil
  end
  
  it "is still loaded once Merb starts" do
    startup_merb
    defined?(Merb::SpecFixture::SimpleGem2).should_not be_nil
  end
end