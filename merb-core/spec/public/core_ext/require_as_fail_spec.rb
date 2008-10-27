require File.join(File.dirname(__FILE__), "spec_helper")

describe "using dependency to require a bad gem" do
  before(:all) do
    Gem.use_paths(File.dirname(__FILE__) / "fixtures" / "gems")
    dependency "bad_require_gem"
  end
  
  it "doesn't load it right away" do
    defined?(Merb::SpecFixture::BadRequireGem).should be_nil
    defined?(Merb::SpecFixture::BadRequireGem).should be_nil
  end
  
  it "raises an error when Merb starts because it can't find the file to require" do
    lambda do
      startup_merb(:show_ugly_backtraces => true)
    end.should raise_error(LoadError)
  end
end