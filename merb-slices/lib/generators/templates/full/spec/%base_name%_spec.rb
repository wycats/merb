require File.dirname(__FILE__) + '/spec_helper'

describe "<%= module_name %> (module)" do
  
  it "should have proper specs"
  
  # Feel free to remove the specs below
  
  before :all do
    Merb::Router.prepare { |r| r.add_slice(:<%= module_name %>) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  it "should be registered in Merb::Slices.slices" do
    Merb::Slices.slices.should include(<%= module_name %>)
  end
  
  it "should be registered in Merb::Slices.paths" do
    Merb::Slices.paths[<%= module_name %>.name].should == current_slice_root
  end
  
  it "should have an :identifier property" do
    <%= module_name %>.identifier.should == "<%= base_name %>"
  end
  
  it "should have an :identifier_sym property" do
    <%= module_name %>.identifier_sym.should == :<%= symbol_name %>
  end
  
  it "should have a :root property" do
    <%= module_name %>.root.should == Merb::Slices.paths[<%= module_name %>.name]
    <%= module_name %>.root_path('app').should == current_slice_root / 'app'
  end
  
  it "should have a :file property" do
    <%= module_name %>.file.should == current_slice_root / 'lib' / '<%= base_name %>.rb'
  end
  
  it "should have metadata properties" do
    <%= module_name %>.description.should == "<%= module_name %> is a chunky Merb slice!"
    <%= module_name %>.version.should == "0.0.1"
    <%= module_name %>.author.should == "YOUR NAME"
  end
  
  it "should have :routes and :named_routes properties" do
    <%= module_name %>.routes.should_not be_empty
    <%= module_name %>.named_routes[:<%= symbol_name %>_index].should be_kind_of(Merb::Router::Route)
  end

  it "should have an url helper method for slice-specific routes" do
    <%= module_name %>.url(:controller => 'main', :action => 'show', :format => 'html').should == "/<%= base_name %>/main/show.html"
    <%= module_name %>.url(:<%= symbol_name %>_index, :format => 'html').should == "/<%= base_name %>/index.html"
  end
  
  it "should have a config property (Hash)" do
    <%= module_name %>.config.should be_kind_of(Hash)
  end
  
  it "should have bracket accessors as shortcuts to the config" do
    <%= module_name %>[:foo] = 'bar'
    <%= module_name %>[:foo].should == 'bar'
    <%= module_name %>[:foo].should == <%= module_name %>.config[:foo]
  end
  
  it "should have a :layout config option set" do
    <%= module_name %>.config[:layout].should == :<%= symbol_name %>
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
  
  it "should have a public_path_for method" do
    public_path = <%= module_name %>.public_dir_for(:public)
    <%= module_name %>.public_path_for("path", "to", "file").should == public_path / "path" / "to" / "file"
    [:stylesheet, :javascript, :image].each do |type|
      <%= module_name %>.public_path_for(type, "path", "to", "file").should == public_path / "#{type}s" / "path" / "to" / "file"
    end
  end
  
  it "should have a app_path_for method" do
    <%= module_name %>.app_path_for("path", "to", "file").should == <%= module_name %>.app_dir_for(:root) / "path" / "to" / "file"
    <%= module_name %>.app_path_for(:controller, "path", "to", "file").should == <%= module_name %>.app_dir_for(:controller) / "path" / "to" / "file"
  end
  
  it "should have a slice_path_for method" do
    <%= module_name %>.slice_path_for("path", "to", "file").should == <%= module_name %>.dir_for(:root) / "path" / "to" / "file"
    <%= module_name %>.slice_path_for(:controller, "path", "to", "file").should == <%= module_name %>.dir_for(:controller) / "path" / "to" / "file"
  end
  
  it "should keep a list of path component types to use when copying files" do
    (<%= module_name %>.mirrored_components & <%= module_name %>.slice_paths.keys).length.should == <%= module_name %>.mirrored_components.length
  end
  
end