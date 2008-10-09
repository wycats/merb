require File.join(File.dirname(__FILE__), "..", 'spec_helper.rb')
require File.join(File.expand_path(File.dirname(__FILE__)), "..", ".." ,"lib", "merb-auth-more", "mixins", "redirect_back")

describe "redirect_back" do
  
  before(:all) do
    clear_strategies!
    
    class Merb::Authentication
      def store_user(user); user; end
      def fetch_user(session_info); session_info; end
    end
    
    class MyStrategy < Merb::Authentication::Strategy; def run!; request.env["USER"]; end; end
    
    class Application < Merb::Controller; end
    
    class Exceptions < Application
      def unauthenticated; end
    end

    class MyController < Application
      before :ensure_authenticated

      def index; "HERE!" end

    end
  end 
  
  it "should set the return_to in the session when sent to the exceptions controller from a failed login" do
    controller = dispatch_to(Exceptions, :unauthenticated, {}, {:user => "winna", :request_uri => "go_back"}) do |c|
      c.request.exceptions =  [Merb::Controller::Unauthenticated.new]
    end
    controller.session.authentication.return_to_url.should == "go_back"
  end
  
  it  "should not set the return_to in the session when deliberately going to unauthenticated" do
    controller = dispatch_to(Exceptions, :unauthenticated, {}, {:user => "winna", :request_uri => "don't_go_back"}) do |c|
      c.request.exceptions = []
    end
    controller.session.authentication.return_to_url.should be_nil
  end
  
  it "should not set the return_to when loggin into a controller directly" do 
    controller = dispatch_to(MyController, :index, {}, :user => "winna", :request_uri => "NOOO")
    controller.session.authentication.return_to_url.should be_nil
  end
  
  describe "redirect_back helper" do
    
    before(:each) do
      @with_redirect = dispatch_to(Exceptions, :unauthenticated, {}, :user => "WINNA", :request_uri => "request_uri") do |c|
        c.request.exceptions = [Merb::Controller::Unauthenticated.new]
      end
      @no_redirect = dispatch_to(MyController, :index, {}, :user => "winna", :request_uri => "NOOO")
    end
    
    it "should provide the url stored in the session" do
      @with_redirect.session.authentication.return_to_url.should == "request_uri"
      @with_redirect.redirect_back_or("/some/path")
      @with_redirect.headers["Location"].should == "request_uri"
    end
    
    it "should provide the url passed in by default when there is no return_to" do
      @no_redirect.session.authentication.return_to_url.should be_nil
      @no_redirect.redirect_back_or("/some/path")
      @no_redirect.headers["Location"].should ==  "/some/path"
    end
    
    it "should wipe out the return_to in the session after the redirect" do
      @with_redirect.session.authentication.return_to_url.should == "request_uri"
      @with_redirect.redirect_back_or("somewhere")
      @with_redirect.headers["Location"].should == "request_uri"
      @with_redirect.session.authentication.return_to_url.should be_nil
    end
    
    it "should ignore a return_to if it's the same as the ignore url" do
      @with_redirect.redirect_back_or("somewhere", :ignore => "request_uri")
      @with_redirect.headers["Location"].should == "somewhere"
    end
     
  end
  
end