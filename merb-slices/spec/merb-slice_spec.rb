require File.dirname(__FILE__) + '/spec_helper'

describe Merb::Slices do
  
  before(:all) do
    # Add the slice to the search path
    Merb::Plugins.config[:merb_slices][:auto_register] = true
    Merb::Plugins.config[:merb_slices][:search_path]   = File.dirname(__FILE__) / 'slices'
    
    Merb.start(
      :testing => true, 
      :adapter => 'runner', 
      :environment => ENV['MERB_ENV'] || 'test',
      :merb_root => Merb.root
    )
  end
  
  before :all do
    Merb::Router.prepare do 
      all_slices
    end
  end
  
  after :all do
    Merb::Router.reset!
  end
  
  it "should be registered in Merb::Slices.slices" do
    Merb::Slices.slices.should include(FullTestSlice)
    Merb::Slices.slices.should include(ThinTestSlice)
    Merb::Slices.slices.should include(VeryThinTestSlice)
  end
  
end

describe "The Merb::Router::Behavior methods" do
    
  before(:all) do
    # Add the slice to the search path
    Merb::Plugins.config[:merb_slices][:auto_register] = true
    Merb::Plugins.config[:merb_slices][:search_path]   = File.dirname(__FILE__) / 'slices'

    Merb.start(
      :testing => true, 
      :adapter => 'runner', 
      :environment => ENV['MERB_ENV'] || 'test',
      :merb_root => Merb.root
    )
  end
  
  before :all do
    Merb::Router.prepare do 
      add_slice(:FullTestSlice, :path_prefix => 'full') do |scope|
        scope.match('/dashboard').to(:controller => 'main', :action => 'index').name(:dashboard)
      end
      add_slice(:thin_test_slice, 'thin') # shortcut for :path => 'thin'
      slice(:very_thin_test_slice, :name_prefix => 'awesome', :params => { :foo => 'bar' })
    end    
  end
  
  after :all do
    Merb::Router.reset!
  end
  
  it "should add a slice's routes and provide access to the namespace through a block using #add_slice" do
    Merb::Router.named_routes[:full_test_slice_default].inspect.should == '/full/:controller(/:action(/:id))(.:format)'
    Merb::Router.named_routes[:full_test_slice_home].inspect.should == '/full'
    Merb::Router.named_routes[:full_test_slice_index].inspect.should == '/full/index(.:format)'
    Merb::Router.named_routes[:full_test_slice_dashboard].inspect.should == '/full/dashboard'
    
    Merb::Router.named_routes[:full_test_slice_default].should == FullTestSlice.named_routes[:default]
    Merb::Router.named_routes[:full_test_slice_index].should == FullTestSlice.named_routes[:index]
    Merb::Router.named_routes[:full_test_slice_dashboard].should == FullTestSlice.named_routes[:dashboard]
  end
  
  it "should add a slice's routes and provide a shortcut for setting the url prefix/path using #add_slice" do
    Merb::Router.named_routes[:thin_test_slice_default].inspect.should == '/thin/:controller(/:action(/:id))(.:format)'
    Merb::Router.named_routes[:thin_test_slice_default].should == ThinTestSlice.named_routes[:default]
  end
  
  it "should mount a slice directly at the root using #slice" do
    Merb::Router.named_routes[:awesome_default].inspect.should == '/:controller(/:action(/:id))(.:format)'
    Merb::Router.named_routes[:awesome_default].should == VeryThinTestSlice.named_routes[:default]
  end
  
  it "should allow default params to be set on a route" do
    Merb::Router.named_routes[:awesome_default].params[:foo].should == '"bar"'
  end
  
  # it "should have setup routes correctly for recognition" do
  #   route_to("/main/index").should have_route(:controller => "home", :action => "index")
  # end
  
end