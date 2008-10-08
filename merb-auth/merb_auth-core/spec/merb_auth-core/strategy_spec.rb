require File.join(File.dirname(__FILE__), "..", 'spec_helper.rb')

describe "Authentication::Strategy" do
    
  before(:all) do
    clear_strategies!
  end
  
  before(:each) do
    clear_strategies!
  end
  
  after(:all) do
    clear_strategies!
  end
  
  describe "adding a strategy" do
    it "should add a strategy" do
      class MyStrategy < Authentication::Strategy; end
      Authentication.strategies.should include(MyStrategy)
    end
    
    it "should keep track of the strategies" do
      class Sone < Authentication::Strategy; end
      class Stwo < Authentication::Strategy; end
      Authentication.strategies.should include(Sone, Stwo)
      Authentication.default_strategy_order.pop
      Authentication.strategies.should include(Sone, Stwo)
    end
    
    it "should add multiple strategies in order of decleration" do
      class Sone < Authentication::Strategy; end
      class Stwo < Authentication::Strategy; end
      Authentication.default_strategy_order.should == [Sone, Stwo]
    end
    
    it "should allow a strategy to be inserted _before_ another strategy in the default order" do
      class Sone < Authentication::Strategy; end
      class Stwo < Authentication::Strategy; end
      class AuthIntruder < Authentication::Strategy; before Stwo; end
      Authentication.strategies.should include(AuthIntruder, Stwo, Sone)
      Authentication.default_strategy_order.should == [Sone, AuthIntruder, Stwo]
    end
    
    it "should allow a strategy to be inserted _after_ another strategy in the default order" do
      class Sone < Authentication::Strategy; end
      class Stwo < Authentication::Strategy; end
      class AuthIntruder < Authentication::Strategy; after Sone; end
      Authentication.strategies.should include(AuthIntruder, Stwo, Sone)
      Authentication.default_strategy_order.should == [Sone, AuthIntruder, Stwo]
    end
  end
  
  describe "the default order" do
    it "should allow a user to overwrite the default order" do
      class Sone < Authentication::Strategy; end
      class Stwo < Authentication::Strategy; end
      Authentication.default_strategy_order = [Stwo]
      Authentication.default_strategy_order.should == [Stwo]
    end
    
    it "should get raise an error if any strategy is not an Authentication::Strategy" do
      class Sone < Authentication::Strategy; end
      class Stwo < Authentication::Strategy; end
      lambda do
        Authentication.default_strategy_order = [Stwo, String]
      end.should raise_error(ArgumentError)
    end
  end

  it "should raise a not implemented error if the run! method is not defined in the subclass" do
    class Sone < Authentication::Strategy; end
    lambda do
      Sone.new("controller").run!
    end.should raise_error(Authentication::NotImplemented)
  end
  
  it "should not raise an implemented error if the run! method is defined on the subclass" do
    class Sone < Authentication::Strategy; def run!; end; end
    lambda do
      Sone.new("controller").run!
    end.should_not raise_error(Authentication::NotImplemented)
  end
  
  describe "convinience methods" do
    
    before(:each) do
      class Sone < Authentication::Strategy; def run!; end; end 
      @request = mock("controller")
      @strategy = Sone.new(@request)
    end
    
    it "should provide a params helper that defers to the controller" do
      @request.should_receive(:params).and_return("PARAMS")
      @strategy.params.should == "PARAMS"
    end
    
    it "should provide a cookies helper" do
      @request.should_receive(:cookies).and_return("COOKIES")
      @strategy.cookies.should == "COOKIES"
    end
    
  end
  
  describe "#user_class" do
    
    # This allows you to scope a particular strategy to a particular user class object
    # By inheriting you can add multiple user types to the authentication process
    
    before(:each) do
      class Sone < Authentication::Strategy; def run!; end; end
      class Stwo < Sone; end
      
      class Mone < Authentication::Strategy
        def user_class; String; end
        def run!; end
      end
      class Mtwo < Mone; end
      
      class Pone < Authentication::Strategy
        abstract!
        def user_class; Hash; end
        def special_method; true end
      end
      class Ptwo < Pone; end;
      
      @request = mock("request", :null_object => true)
    end
    
    it "should allow being set to an abstract strategy" do
      Pone.abstract?.should be_true
    end
    
    it "should not set the child class of an abstract class to be abstract" do
      Ptwo.abstract?.should be_false
    end
    
    it "should implement a user_class helper" do
      s = Sone.new(@request)
      s.user_class.should == User
    end
    
    it "should make it into the strategies collection when subclassed from a subclass" do
      Authentication.strategies.should include(Mtwo)
    end
    
    it "should make it in the default_strategy_order when subclassed from a subclass" do
      Authentication.default_strategy_order.should include(Mtwo)
    end
    
    it "should defer to the Authentication.user_class if not over written" do
      Authentication.should_receive(:user_class).and_return(User)
      s = Sone.new(@request)
      s.user_class
    end
    
    it "should inherit the user class from it's parent by default" do
      Authentication.should_receive(:user_class).and_return(User)
      s = Stwo.new(@request)
      s.user_class.should == User
    end
    
    it "should inherit the user_class form it's parent when the parent defines a new one" do
      Authentication.should_not_receive(:user_class)
      m = Mtwo.new(@request)
      m.user_class.should == String
    end
    
  end
  
  describe "#redirect!" do
    
    before(:all) do
      class FooController < Merb::Controller
        def index; "FooController#index" end
      end
    end
    
    before(:each) do
      class MyStrategy < Authentication::Strategy
        def run!
          if params[:url]
            params[:status] ? redirect!(params[:url], :status => params[:status]) : redirect!(params[:url])
          else
            "WINNA"
          end
        end
      end # MyStrategy
      
      Merb::Router.reset!
      Merb::Router.prepare{ match("/").to(:controller => "foo_controller")}
      @request = mock_request("/")
      @s = MyStrategy.new(@request)
    end
    
    it "allow for a redirect!" do
      @s.redirect!("/somewhere")
      @s.redirect_url.should == "/somewhere"
    end
    
    it "should set redirect_options as an empty hash" do
      @s.redirect!("/somewhere")
      @s.redirect_options.should == {}
    end
    
    it "should return nil for the redirect_url if it is not redirected" do
      @s.should_not be_redirected
      @s.redirect_url.should be_nil
    end
      
    it "should pass through the options to the redirect options" do
      @s.redirect!("/somewhere", :status => 401)
      @s.redirect_options.should == {:status => 401}
    end
    
    it "should set a redirect with a permanent true" do
      @s.redirect!("/somewhere", :permanent => true)
      @s.redirect_options.should == {:permanent => true}
    end
    
    it "should be redirected?" do
      @s.should_not be_redirected
      @s.redirect!("/somewhere")
      @s.should be_redirected
    end
    
  end
  
end