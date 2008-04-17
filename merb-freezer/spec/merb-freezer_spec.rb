require File.dirname(__FILE__) + '/spec_helper'

describe "merb-freezer" do
  
  before(:each) do
    FileUtils.rm_rf('framework')
    FileUtils.rm_rf('gems')
  end
  
  after(:all) do
    FileUtils.rm_rf('framework')
    FileUtils.rm_rf('gems')
  end
  
  it "should have a reference to all the git repos" do
    Freezer.components.should be_an_instance_of(Hash)
    component_repos = Freezer.components
    ["core", "more", "plugins"].each do |component|
      component_repos[component].should match(/git:\/\/.+/)
    end
  end
  
  it "should have a reference to the framework dir" do
    Freezer.framework_dir.should_not be_nil
  end
  
  it "should have a reference to the gems dir" do
    Freezer.gems_dir.should_not be_nil
  end
  
  it "should have a reference to the component freezing dir" do
    mr_freeze = Freezer.new('core')
    mr_freeze.freezer_dir.should == Freezer.framework_dir
    
    mrs_freeze = Freezer.new('matt-mojo')
    mrs_freeze.freezer_dir.should == Freezer.gems_dir
  end
  
  it "should be able to freeze a component using rubygems" do
    mr_freeze = Freezer.new('core', nil, 'rubygems')
    mr_freeze.mode.should == 'rubygems'
    mr_freeze.freeze
    File.exists?('framework').should be_true
    File.exists?('framework/gems').should be_true
  end
  
  it "should be able to freeze a component using submodules" do
    mr_freeze = Freezer.new('core')
    mr_freeze.framework_component?.should be_true
    mr_freeze.mode.should == 'submodules'
    # can't be tested since it needs to run from the toplevel of the working tree and I don't want to mess up the rest of the gems by accident
    # mr_freeze.freeze.should_not raise_error
    # File.exists?('framework/merb-core').should be_true
    # File.exists?('.gitmodules').should be_true
  end
  
  it "should be able to freeze a a non merb component gem using rubygems" do
    mr_freeze = Freezer.new('googlecharts')
    mr_freeze.framework_component?.should be_false
    mr_freeze.component.should == 'googlecharts'
    mr_freeze.mode.should == 'rubygems'
    mr_freeze.freeze
    File.exists?('gems').should be_true
    File.exists?('gems/gems/googlecharts-1.1.0').should be_true
  end
  
end