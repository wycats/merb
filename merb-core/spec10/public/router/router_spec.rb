require File.join(File.dirname(__FILE__), "spec_helper")

describe Merb::Router do
  
  describe "#prepare" do
    
    it "should be able to compile an empty route table" do
      lambda do
        Merb::Router.prepare { }
      end.should_not raise_error(SyntaxError)
    end
    
    it "should evaluate the prepare block in context an object that provides builder methods" do
      Merb::Router.prepare do
        %w(
          match to defaults options fixatable
          name full_name defer_to default_routes
          namespace redirect resources resource
        ).each do |method|
          respond_to?(method).should == true
        end
      end
    end
    
    it "should use the default root_behavior if none is specified" do
      Merb::Router.prepare do
        match("/hello").to(:controller => "hello")
      end
      
      route_for("/hello").should have_route(:controller => "hello", :action => "index")
    end
    
    it "should use the root_behavior specified externally" do
      Merb::Router.root_behavior = Merb::Router.root_behavior.defaults(:controller => "default")
      Merb::Router.prepare do
        match("/hello").register
      end
      
      route_for("/hello").should have_route(:controller => "default", :action => "index")
    end
    
    it "should be able to chain root_behaviors" do
      Merb::Router.root_behavior = Merb::Router.root_behavior.defaults(:controller => "default")
      Merb::Router.root_behavior = Merb::Router.root_behavior.defaults(:action     => "default")
      Merb::Router.prepare do
        match("/hello").register
      end
      
      route_for("/hello").should have_route(:controller => "default", :action => "default")
    end
    
    it "should raise a friendly error when there is some :controller mismatching going on" do
      lambda {
        Merb::Router.prepare do
          match("/").to(:controller => "hello/:controller")
        end
      }.should raise_error(Merb::Router::GenerationError)
    end
    
    it "should empty previously set #routes, #resource_routes, and #named_routes" do
      Merb::Router.prepare do
        resources :users
      end
      Merb::Router.prepare { }
      
      Merb::Router.routes.should be_empty
      Merb::Router.named_routes.should be_empty
      Merb::Router.resource_routes.should be_empty
    end
    
    it "should not be able to match routes anymore" do
      lambda { route_for("/users") }.should raise_error(Merb::Router::NotCompiledError)
    end
    
    it "should log at the debug level when it cannot find a resource model" do
      with_level(:info) do
        Merb::Router.prepare { resources :zomghi2u }
      end.should_not include_log("Could not find resource model Zonghi2u")
      
      with_level(:debug) do
        Merb::Router.prepare { resources :zomghi2u }
      end.should include_log("Could not find resource model Zomghi2u")
    end
  end

  describe "#match" do
    
    it "should raise an error if the routes were not compiled yet" do
      lambda { Merb::Router.match(simple_request) }.should raise_error(Merb::Router::NotCompiledError)
    end

  end
  
  describe "#extensions" do
    it "should be able to extend the router" do
      Merb::Router.extensions do
        def hello_world
          match("/hello").to(:controller => "world")
        end
      end
      
      Merb::Router.prepare do
        hello_world
      end
      
      route_for("/hello").should have_route(:controller => "world")
    end
  end
  
  describe "#around_match" do
    
    it "should set a class method of Router to be called around request matching" do
      class Merb::Router
        def self.my_awesome_thang(request)
          before!
          retval = yield
          after!
          retval
        end
      end
      
      Merb::Router.around_match = :my_awesome_thang
      Merb::Router.prepare do
        match("/").to(:controller => "home")
      end
      
      Merb::Router.should_receive(:before!)
      Merb::Router.should_receive(:after!)
      route_for("/").should have_route(:controller => "home")
    end
    
  end

end