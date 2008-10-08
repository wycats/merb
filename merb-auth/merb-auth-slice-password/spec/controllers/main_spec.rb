require File.dirname(__FILE__) + '/../spec_helper'

describe "MerbAuthSlicePassword::Main (controller)" do
  
  # Feel free to remove the specs below
  
  before :all do
    Merb::Router.prepare { |r| r.add_slice(:MerbAuthSlicePassword) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  it "should have access to the slice module" do
    controller = dispatch_to(MerbAuthSlicePassword::Main, :index)
    controller.slice.should == MerbAuthSlicePassword
    controller.slice.should == MerbAuthSlicePassword::Main.slice
  end
  
  it "should have an index action" do
    controller = dispatch_to(MerbAuthSlicePassword::Main, :index)
    controller.status.should == 200
    controller.body.should contain('MerbAuthSlicePassword')
  end
  
  it "should work with the default route" do
    controller = get("/mauth_password_slice/main/index")
    controller.should be_kind_of(MerbAuthSlicePassword::Main)
    controller.action_name.should == 'index'
  end
  
  it "should work with the example named route" do
    controller = get("/mauth_password_slice/index.html")
    controller.should be_kind_of(MerbAuthSlicePassword::Main)
    controller.action_name.should == 'index'
  end
  
  it "should have routes in MerbAuthSlicePassword.routes" do
    MerbAuthSlicePassword.routes.should_not be_empty
  end
  
  it "should have a slice_url helper method for slice-specific routes" do
    controller = dispatch_to(MerbAuthSlicePassword::Main, 'index')
    controller.slice_url(:action => 'show', :format => 'html').should == "/mauth_password_slice/main/show.html"
    controller.slice_url(:mauth_password_slice_index, :format => 'html').should == "/mauth_password_slice/index.html"
  end
  
  it "should have helper methods for dealing with public paths" do
    controller = dispatch_to(MerbAuthSlicePassword::Main, :index)
    controller.public_path_for(:image).should == "/slices/mauth_password_slice/images"
    controller.public_path_for(:javascript).should == "/slices/mauth_password_slice/javascripts"
    controller.public_path_for(:stylesheet).should == "/slices/mauth_password_slice/stylesheets"
  end
  
  it "should have a slice-specific _template_root" do
    MerbAuthSlicePassword::Main._template_root.should == MerbAuthSlicePassword.dir_for(:view)
    MerbAuthSlicePassword::Main._template_root.should == MerbAuthSlicePassword::Application._template_root
  end

end