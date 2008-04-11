require File.dirname(__FILE__) + '/spec_helper'

describe "merb-freezer" do
  
  before(:each) do
    FileUtils.rm_rf('framework')
  end
  
  after(:all) do
    FileUtils.rm_rf('framework')
  end
  
  it "should have a reference to all the git repos" do
    Freezer.components.should be_an_instance_of(Hash)
    component_repos = Freezer.components
    ["core", "more", "plugins"].each do |component|
      component_repos[component].should match(/git:\/\/.+/)
    end
  end
  
  it "should have a reference of the framework dir" do
    Freezer.framework_dir.should_not be_nil
  end
  
  it "should be able to freeze a component using rubygems" do
    Freezer.new('core', nil, 'rubygems').freeze
    File.exists?('framework').should be_true
    File.exists?('framework/gems').should be_true
  end
  
  # it "should be able to freeze a component using submodules" do
  #   Freezer.new('core').freeze
  # end
  
end