require File.dirname(__FILE__) + '/spec_helper'

describe "MerbAuthSlicePassword (module)" do
  
  it "should have proper specs"
  
  # Feel free to remove the specs below
  
  before :all do
    Merb::Router.prepare { |r| r.add_slice(:MerbAuthSlicePassword) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  it "should be registered in Merb::Slices.slices" do
    Merb::Slices.slices.should include(MerbAuthSlicePassword)
  end
  
  it "should be registered in Merb::Slices.paths" do
    Merb::Slices.paths[MerbAuthSlicePassword.name].should == current_slice_root
  end
  
  it "should have an :identifier property" do
    MerbAuthSlicePassword.identifier.should == "mauth_password_slice"
  end
  
  it "should have an :identifier_sym property" do
    MerbAuthSlicePassword.identifier_sym.should == :mauth_password_slice
  end
  
  it "should have a :root property" do
    MerbAuthSlicePassword.root.should == Merb::Slices.paths[MerbAuthSlicePassword.name]
    MerbAuthSlicePassword.root_path('app').should == current_slice_root / 'app'
  end
  
  it "should have a :file property" do
    MerbAuthSlicePassword.file.should == current_slice_root / 'lib' / 'mauth_password_slice.rb'
  end
  
  it "should have metadata properties" do
    MerbAuthSlicePassword.description.should == "MerbAuthSlicePassword is a chunky Merb slice!"
    MerbAuthSlicePassword.version.should == "0.0.1"
    MerbAuthSlicePassword.author.should == "YOUR NAME"
  end
  
  it "should have :routes and :named_routes properties" do
    MerbAuthSlicePassword.routes.should_not be_empty
    MerbAuthSlicePassword.named_routes[:mauth_password_slice_index].should be_kind_of(Merb::Router::Route)
  end

  it "should have an url helper method for slice-specific routes" do
    MerbAuthSlicePassword.url(:controller => 'main', :action => 'show', :format => 'html').should == "/mauth_password_slice/main/show.html"
    MerbAuthSlicePassword.url(:mauth_password_slice_index, :format => 'html').should == "/mauth_password_slice/index.html"
  end
  
  it "should have a config property (Hash)" do
    MerbAuthSlicePassword.config.should be_kind_of(Hash)
  end
  
  it "should have bracket accessors as shortcuts to the config" do
    MerbAuthSlicePassword[:foo] = 'bar'
    MerbAuthSlicePassword[:foo].should == 'bar'
    MerbAuthSlicePassword[:foo].should == MerbAuthSlicePassword.config[:foo]
  end
  
  it "should have a :layout config option set" do
    MerbAuthSlicePassword.config[:layout].should == :mauth_password_slice
  end
  
  it "should have a dir_for method" do
    app_path = MerbAuthSlicePassword.dir_for(:application)
    app_path.should == current_slice_root / 'app'
    [:view, :model, :controller, :helper, :mailer, :part].each do |type|
      MerbAuthSlicePassword.dir_for(type).should == app_path / "#{type}s"
    end
    public_path = MerbAuthSlicePassword.dir_for(:public)
    public_path.should == current_slice_root / 'public'
    [:stylesheet, :javascript, :image].each do |type|
      MerbAuthSlicePassword.dir_for(type).should == public_path / "#{type}s"
    end
  end
  
  it "should have a app_dir_for method" do
    root_path = MerbAuthSlicePassword.app_dir_for(:root)
    root_path.should == Merb.root / 'slices' / 'mauth_password_slice'
    app_path = MerbAuthSlicePassword.app_dir_for(:application)
    app_path.should == root_path / 'app'
    [:view, :model, :controller, :helper, :mailer, :part].each do |type|
      MerbAuthSlicePassword.app_dir_for(type).should == app_path / "#{type}s"
    end
    public_path = MerbAuthSlicePassword.app_dir_for(:public)
    public_path.should == Merb.dir_for(:public) / 'slices' / 'mauth_password_slice'
    [:stylesheet, :javascript, :image].each do |type|
      MerbAuthSlicePassword.app_dir_for(type).should == public_path / "#{type}s"
    end
  end
  
  it "should have a public_dir_for method" do
    public_path = MerbAuthSlicePassword.public_dir_for(:public)
    public_path.should == '/slices' / 'mauth_password_slice'
    [:stylesheet, :javascript, :image].each do |type|
      MerbAuthSlicePassword.public_dir_for(type).should == public_path / "#{type}s"
    end
  end
  
  it "should have a public_path_for method" do
    public_path = MerbAuthSlicePassword.public_dir_for(:public)
    MerbAuthSlicePassword.public_path_for("path", "to", "file").should == public_path / "path" / "to" / "file"
    [:stylesheet, :javascript, :image].each do |type|
      MerbAuthSlicePassword.public_path_for(type, "path", "to", "file").should == public_path / "#{type}s" / "path" / "to" / "file"
    end
  end
  
  it "should have a app_path_for method" do
    MerbAuthSlicePassword.app_path_for("path", "to", "file").should == MerbAuthSlicePassword.app_dir_for(:root) / "path" / "to" / "file"
    MerbAuthSlicePassword.app_path_for(:controller, "path", "to", "file").should == MerbAuthSlicePassword.app_dir_for(:controller) / "path" / "to" / "file"
  end
  
  it "should have a slice_path_for method" do
    MerbAuthSlicePassword.slice_path_for("path", "to", "file").should == MerbAuthSlicePassword.dir_for(:root) / "path" / "to" / "file"
    MerbAuthSlicePassword.slice_path_for(:controller, "path", "to", "file").should == MerbAuthSlicePassword.dir_for(:controller) / "path" / "to" / "file"
  end
  
  it "should keep a list of path component types to use when copying files" do
    (MerbAuthSlicePassword.mirrored_components & MerbAuthSlicePassword.slice_paths.keys).length.should == MerbAuthSlicePassword.mirrored_components.length
  end
  
end