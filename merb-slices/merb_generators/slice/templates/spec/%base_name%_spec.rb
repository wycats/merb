require File.dirname(__FILE__) + '/spec_helper'

describe "<%= module_name %> (module)" do
  
  it "should have proper specs"
  
  # Feel free to remove the specs below
  
  it "should be registered in Merb::Slices.slices" do
    Merb::Slices.slices.should include(<%= module_name %>)
  end
  
  it "should have an :identifier property" do
    <%= module_name %>.identifier.should == "<%= base_name %>"
  end
  
  it "should have an :identifier_sym property" do
    <%= module_name %>.identifier_sym.should == :<%= underscored_name %>
  end
  
  it "should have a :root property" do
    <%= module_name %>.root.should == current_slice_root
    <%= module_name %>.root_path('app').should == current_slice_root / 'app'
  end
  
  it "should have metadata properties" do
    <%= module_name %>.description.should == "<%= module_name %> is a chunky Merb slice!"
    <%= module_name %>.version.should == "0.0.1"
    <%= module_name %>.author.should == "YOUR NAME"
  end
  
  it "should have a config property (Hash)" do
    <%= module_name %>.config.should be_kind_of(Hash)
  end
  
  it "should have a bracket accessors as shortcuts to the config" do
    <%= module_name %>[:foo] = 'bar'
    <%= module_name %>[:foo].should == 'bar'
    <%= module_name %>[:foo].should == <%= module_name %>.config[:foo]
  end
  
  it "should have a :layout config option set" do
    <%= module_name %>.config[:layout].should == :<%= underscored_name %>
  end
  
  it "should have a dir_for method" do
    app_path = <%= module_name %>.dir_for(:application)
    app_path.should == current_slice_root / 'app'
    [:view, :model, :controller, :helper, :mailer, :part].each do |type|
      <%= module_name %>.dir_for(type).should == app_path / "#{type}s"
    end
    public_path = <%= module_name %>.dir_for(:public)
    public_path.should == current_slice_root / 'public'
    [:stylesheet, :javascript, :image].each do |type|
      <%= module_name %>.dir_for(type).should == public_path / "#{type}s"
    end
  end
  
  it "should have a app_dir_for method" do
    root_path = <%= module_name %>.app_dir_for(:root)
    root_path.should == Merb.root / 'slices' / '<%= base_name %>'
    app_path = <%= module_name %>.app_dir_for(:application)
    app_path.should == root_path / 'app'
    [:view, :model, :controller, :helper, :mailer, :part].each do |type|
      <%= module_name %>.app_dir_for(type).should == app_path / "#{type}s"
    end
    public_path = <%= module_name %>.app_dir_for(:public)
    public_path.should == Merb.dir_for(:public) / 'slices' / '<%= base_name %>'
    [:stylesheet, :javascript, :image].each do |type|
      <%= module_name %>.app_dir_for(type).should == public_path / "#{type}s"
    end
  end
  
  it "should have a public_dir_for method" do
    public_path = <%= module_name %>.public_dir_for(:public)
    public_path.should == '/slices' / '<%= base_name %>'
    [:stylesheet, :javascript, :image].each do |type|
      <%= module_name %>.public_dir_for(type).should == public_path / "#{type}s"
    end
  end
  
  it "should keep a list of path component types to use when copying files" do
    (<%= module_name %>.mirrored_components & <%= module_name %>.slice_paths.keys).length.should == <%= module_name %>.mirrored_components.length
  end
  
end