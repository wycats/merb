require File.dirname(__FILE__) + '/spec_helper'

describe "MerbAuthPasswordSlice (module)" do
  
  it "should have proper specs"
  
  # Feel free to remove the specs below
  
  before :all do
    Merb::Router.prepare { |r| r.add_slice(:MerbAuthPasswordSlice) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  it "should be registered in Merb::Slices.slices" do
    Merb::Slices.slices.should include(MerbAuthPasswordSlice)
  end
  
  it "should be registered in Merb::Slices.paths" do
    Merb::Slices.paths[MerbAuthPasswordSlice.name].should == current_slice_root
  end
  
  it "should have an :identifier property" do
    MerbAuthPasswordSlice.identifier.should == "mauth_password_slice"
  end
  
  it "should have an :identifier_sym property" do
    MerbAuthPasswordSlice.identifier_sym.should == :mauth_password_slice
  end
  
  it "should have a :root property" do
    MerbAuthPasswordSlice.root.should == Merb::Slices.paths[MerbAuthPasswordSlice.name]
    MerbAuthPasswordSlice.root_path('app').should == current_slice_root / 'app'
  end
  
  it "should have a :file property" do
    MerbAuthPasswordSlice.file.should == current_slice_root / 'lib' / 'mauth_password_slice.rb'
  end
  
  it "should have metadata properties" do
    MerbAuthPasswordSlice.description.should == "MerbAuthPasswordSlice is a chunky Merb slice!"
    MerbAuthPasswordSlice.version.should == "0.0.1"
    MerbAuthPasswordSlice.author.should == "YOUR NAME"
  end
  
  it "should have :routes and :named_routes properties" do
    MerbAuthPasswordSlice.routes.should_not be_empty
    MerbAuthPasswordSlice.named_routes[:mauth_password_slice_index].should be_kind_of(Merb::Router::Route)
  end

  it "should have an url helper method for slice-specific routes" do
    MerbAuthPasswordSlice.url(:controller => 'main', :action => 'show', :format => 'html').should == "/mauth_password_slice/main/show.html"
    MerbAuthPasswordSlice.url(:mauth_password_slice_index, :format => 'html').should == "/mauth_password_slice/index.html"
  end
  
  it "should have a config property (Hash)" do
    MerbAuthPasswordSlice.config.should be_kind_of(Hash)
  end
  
  it "should have bracket accessors as shortcuts to the config" do
    MerbAuthPasswordSlice[:foo] = 'bar'
    MerbAuthPasswordSlice[:foo].should == 'bar'
    MerbAuthPasswordSlice[:foo].should == MerbAuthPasswordSlice.config[:foo]
  end
  
  it "should have a :layout config option set" do
    MerbAuthPasswordSlice.config[:layout].should == :mauth_password_slice
  end
  
  it "should have a dir_for method" do
    app_path = MerbAuthPasswordSlice.dir_for(:application)
    app_path.should == current_slice_root / 'app'
    [:view, :model, :controller, :helper, :mailer, :part].each do |type|
      MerbAuthPasswordSlice.dir_for(type).should == app_path / "#{type}s"
    end
    public_path = MerbAuthPasswordSlice.dir_for(:public)
    public_path.should == current_slice_root / 'public'
    [:stylesheet, :javascript, :image].each do |type|
      MerbAuthPasswordSlice.dir_for(type).should == public_path / "#{type}s"
    end
  end
  
  it "should have a app_dir_for method" do
    root_path = MerbAuthPasswordSlice.app_dir_for(:root)
    root_path.should == Merb.root / 'slices' / 'mauth_password_slice'
    app_path = MerbAuthPasswordSlice.app_dir_for(:application)
    app_path.should == root_path / 'app'
    [:view, :model, :controller, :helper, :mailer, :part].each do |type|
      MerbAuthPasswordSlice.app_dir_for(type).should == app_path / "#{type}s"
    end
    public_path = MerbAuthPasswordSlice.app_dir_for(:public)
    public_path.should == Merb.dir_for(:public) / 'slices' / 'mauth_password_slice'
    [:stylesheet, :javascript, :image].each do |type|
      MerbAuthPasswordSlice.app_dir_for(type).should == public_path / "#{type}s"
    end
  end
  
  it "should have a public_dir_for method" do
    public_path = MerbAuthPasswordSlice.public_dir_for(:public)
    public_path.should == '/slices' / 'mauth_password_slice'
    [:stylesheet, :javascript, :image].each do |type|
      MerbAuthPasswordSlice.public_dir_for(type).should == public_path / "#{type}s"
    end
  end
  
  it "should have a public_path_for method" do
    public_path = MerbAuthPasswordSlice.public_dir_for(:public)
    MerbAuthPasswordSlice.public_path_for("path", "to", "file").should == public_path / "path" / "to" / "file"
    [:stylesheet, :javascript, :image].each do |type|
      MerbAuthPasswordSlice.public_path_for(type, "path", "to", "file").should == public_path / "#{type}s" / "path" / "to" / "file"
    end
  end
  
  it "should have a app_path_for method" do
    MerbAuthPasswordSlice.app_path_for("path", "to", "file").should == MerbAuthPasswordSlice.app_dir_for(:root) / "path" / "to" / "file"
    MerbAuthPasswordSlice.app_path_for(:controller, "path", "to", "file").should == MerbAuthPasswordSlice.app_dir_for(:controller) / "path" / "to" / "file"
  end
  
  it "should have a slice_path_for method" do
    MerbAuthPasswordSlice.slice_path_for("path", "to", "file").should == MerbAuthPasswordSlice.dir_for(:root) / "path" / "to" / "file"
    MerbAuthPasswordSlice.slice_path_for(:controller, "path", "to", "file").should == MerbAuthPasswordSlice.dir_for(:controller) / "path" / "to" / "file"
  end
  
  it "should keep a list of path component types to use when copying files" do
    (MerbAuthPasswordSlice.mirrored_components & MerbAuthPasswordSlice.slice_paths.keys).length.should == MerbAuthPasswordSlice.mirrored_components.length
  end
  
end