require File.join(File.dirname(__FILE__), "spec_helper")

require File.join(File.dirname(__FILE__), "controllers", "url")

class Monkey ; def to_param ; 45 ; end ; end
class Donkey ; def to_param ; 19 ; end ; end
class Blue
  def to_param ; 13 ; end
  def monkey_id ; Monkey.new ; end
  def donkey_id ; Donkey.new ; end
end
class Pink
  def to_param ; 22 ; end
  def blue_id ; Blue.new ; end
  def monkey_id ; blue_id.monkey_id ; end
end

describe Merb::Controller, " url" do
  
  before(:each) do
    Merb::Router.prepare do
      identify :to_param do
        resources :monkeys do
          resources :blues do
            resources :pinks
          end
        end
        resources :donkeys do
          resources :blues
        end
        resource :red do
          resources :blues
        end
        match(%r{/foo/(\d+)/}).to(:controller => 'asdf').name(:regexp)
        match('/people(/:name)(.:format)').to(:controller => 'people', :action => 'show').name(:person)
        match('/argstrs').to(:controller => "args").name(:args)
        default_routes
      end
    end
    
    @controller = dispatch_to(Merb::Test::Fixtures::Controllers::Url, :index)
  end
  
  it "should match the :controller to the default route" do
    @controller.url(:controller => "monkeys").should eql("/monkeys")
  end

  it "should match the :controller,:action to the default route" do
    @controller.url(:controller => "monkeys", :action => "list").
      should eql("/monkeys/list")
  end
  
  it "should match the :controller,:action,:id to the default route" do
    @controller.url(:controller => "monkeys", :action => "list", :id => 4).
      should eql("/monkeys/list/4")
  end
  
  it "should match the :controller,:action,:id,:format to the default route" do
    @controller.url(:controller => "monkeys", :action => "list", :id => 4, :format => "xml").
      should eql("/monkeys/list/4.xml")
  end
  
  it "should match the :controller,:action,:id,:format,:fragment to the default route" do
    @controller.url(:controller => "monkeys", :action => "list", :id => 4, :format => "xml", :fragment => :half_way).
      should eql("/monkeys/list/4.xml#half_way")
  end

  it "should raise an error when trying to generate a regexp route" do
    lambda { @controller.url(:regexp) }.should raise_error(Merb::Router::GenerationError)
  end
  
  it "should raise an error when trying to generate a route that doesn't exist" do
    lambda { @controller.url(:lalalala) }.should raise_error(Merb::Router::GenerationError)
  end

  it "should match with a route param" do
    @controller.url(:person, :name => "david").should eql("/people/david")
  end

  it "should match without a route param" do
    @controller.url(:person).should eql("/people")
  end

  it "should match with an additional param" do
    @controller.url(:person, :name => 'david', :color => 'blue').should eql("/people/david?color=blue")
  end
  
  it "should match with a :format" do
    @controller.url(:person, :name => 'david', :format => :xml).should eql("/people/david.xml")
  end
  
  it "should match with a :fragment" do
    @controller.url(:person, :name => 'david', :fragment => :half_way).should eql("/people/david#half_way")
  end
  
  it "should match with an additional param and :format" do
    @controller.url(:person, :name => 'david', :color => 'blue', :format => :xml).should eql("/people/david.xml?color=blue")
  end
  
  it "should match with an additional param, :format, and :fragment" do
    @controller.url(:person, :name => 'david', :color => 'blue', :format => :xml, :fragment => :half_way).
      should eql("/people/david.xml?color=blue#half_way")
  end
  
  it "should match with additional params" do
    url = @controller.url(:person, :name => 'david', :smell => 'funky', :color => 'blue')
    url.should match(%r{/people/david?.*color=blue})
    url.should match(%r{/people/david?.*smell=funky})
  end

  it "should match with extra params and an array" do
    @controller.url(:args, :monkey => [1,2]).should == "/argstrs?monkey[]=1&monkey[]=2"
  end
  
  it "should match with no second arg" do
    @controller.url(:monkeys).should == "/monkeys"
  end
  
  it "should match with an object as second arg" do
    @monkey = Monkey.new
    @controller.url(:monkey, @monkey).should == "/monkeys/45"
  end
  
  it "should match with a fixnum as second arg" do
    @controller.url(:monkey, 3).should == "/monkeys/3"
  end
  
  it "should match with an object and :format" do
    @monkey = Monkey.new
    @controller.url(:monkey, :id => @monkey, :format => :xml).should == "/monkeys/45.xml"
  end
  
  it "should match with an object, :format and additional options" do
    @monkey = Monkey.new
    @controller.url(:monkey, :id => @monkey, :format => :xml, :color => "blue").should == "/monkeys/45.xml?color=blue"
  end
  
  it "should match with an object, :format, :fragment, and additional options" do
    @monkey = Monkey.new
    @controller.url(:monkey, :id => @monkey, :format => :xml, :color => "blue", :fragment => :half_way).should == "/monkeys/45.xml?color=blue#half_way"
  end

  it "should match the delete_monkey route" do
    @monkey = Monkey.new
    @controller.url(:delete_monkey, @monkey).should == "/monkeys/45/delete"
  end
  
  it "should match the delete_red route" do
    @controller.url(:delete_red).should == "/red/delete"
  end

  it "should add a path_prefix to the url if :path_prefix is set" do
    Merb::Config[:path_prefix] = "/jungle"
    @controller.url(:monkeys).should == "/jungle/monkeys"
    Merb::Config[:path_prefix] = nil
  end
 
  it "should match a nested resources show action" do
    @blue = Blue.new
    @controller.url(:monkey_blue, @blue.monkey_id, @blue).should == "/monkeys/45/blues/13"
  end
  
  it "should match the index action of nested resource with parent object" do
    @blue = Blue.new
    @monkey = Monkey.new
    @controller.url(:monkey_blues, :monkey_id => @monkey).should == "/monkeys/45/blues"
  end
  
  it "should match the index action of nested resource with parent id as string" do
    @blue = Blue.new
    @controller.url(:monkey_blues, :monkey_id => '1').should == "/monkeys/1/blues"
  end
  
  it "should match the edit action of nested resource" do
    @blue = Blue.new
    @controller.url(:edit_monkey_blue, @blue.monkey_id, @blue).should == "/monkeys/45/blues/13/edit"
  end
  
  it "should match the index action of resources nested under a resource" do
    @blue = Blue.new
    @controller.url(:red_blues).should == "/red/blues"
  end
  
  it "should match resource that has been nested multiple times" do
    @blue = Blue.new
    @controller.url(:donkey_blue, @blue.donkey_id, @blue).should == "/donkeys/19/blues/13"
    @controller.url(:monkey_blue, @blue.monkey_id, @blue).should == "/monkeys/45/blues/13"
  end
  
  it "should match resources nested more than one level deep" do
    @pink = Pink.new
    @controller.url(:monkey_blue_pink, @pink.blue_id.monkey_id, @pink.blue_id, @pink).should == "/monkeys/45/blues/13/pinks/22"
  end

  it "should match resource with additional params" do
    @monkey = Monkey.new
    @controller.url(:monkey, @monkey, :foo => "bar").should == "/monkeys/45?foo=bar"
  end
  it "should match resource with fragment" do
    @monkey = Monkey.new
    @controller.url(:monkey, @monkey, :fragment => :half_way).should == "/monkeys/45#half_way"
  end

  it "should match a nested resource with additional params" do
    @blue = Blue.new
    @controller.url(:monkey_blue, @blue.monkey_id, @blue, :foo => "bar").should == "/monkeys/45/blues/13?foo=bar"
  end
  
  it "should match a nested resource with additional params and fragment" do
    @blue = Blue.new
    @controller.url(:monkey_blue, @blue.monkey_id, @blue, :foo => "bar", :fragment => :half_way).should == "/monkeys/45/blues/13?foo=bar#half_way"
  end

end

describe Merb::Controller, "#url(:this, *args)" do
  
  before(:each) do
    Merb::Router.prepare do
      with(:controller => "merb/test/fixtures/controllers/url", :action => "this_route") do
        
        resources :users, :controller => "merb/test/fixtures/controllers/url" do
          resources :comments, :controller => "merb/test/fixtures/controllers/url"
        end
        
        resource :profile, :controller => "merb/test/fixtures/controllers/url"
        
        match(%r[/regex]).register
        match("/simple").register
        match("/no_optionals(/:one(/:two))").register
        match("/one_optionals(/:one(/:two))").to(:action => "one_optionals")
        match("/two_optionals(/:one(/:two))").to(:action => "two_optionals")
        match("/postage", :method => :post).register
        match("/action/:action").to(:action => "[1]")
        match("/defer").defer_to { |r, params| params }
        match(:method => :get).defer_to { |r, params| params }
      end
    end
  end
  
  it "should use the current route" do
    request("/simple").body.to_s.should == "/simple"
  end
  
  it "should be able to generate a route with optional segments" do
    request("/no_optionals").body.to_s.should == "/no_optionals"
  end
  
  it "should drop the optional request params if they are not specified when generating the route" do
    request("/no_optionals/one/two").body.to_s.should == "/no_optionals"
  end
  
  it "should generate the optional segments as specified" do
    request("/one_optionals/one/two").body.to_s.should == "/one_optionals/one"
    request("/two_optionals/one/two").body.to_s.should == "/two_optionals/one/two"
  end
  
  it "should generate the route even if it is not a GET request" do
    request("/postage", :method => "post").body.to_s.should == "/postage"
  end
  
  it "should be able to tag on extra query string paramters" do
    request('/action/this_route_with_page').body.to_s.should == "/action/this_route_with_page?page=2"
  end
  
  it "should work with deferred block routes" do
    request("/defer").body.to_s.should == "/defer"
  end
  
  it "should not work with routes that do not have a path" do
    request("/foo/bar").should have_xpath("//h1[contains(.,'Generation Error')]")
  end
  
  it "should raise an error when trying to generate a regexp route" do
    request("/regex").should have_xpath("//h1[contains(.,'Generation Error')]")
  end
  
  it "should work with resource routes" do
    request("/users").body.to_s.should         == "/users"
    request("/users/10").body.to_s.should      == "/users/10"
    request("/users/new").body.to_s.should     == "/users/new"
    request("/users/10/edit").body.to_s.should == "/users/10/edit"
    request("/profile").body.to_s.should       == "/profile"
  end
  
  it "should work with nested resource routes" do
    request("/users/10/comments").body.to_s.should        == "/users/10/comments"
    request("/users/10/comments/9").body.to_s.should      == "/users/10/comments/9"
    request("/users/10/comments/new").body.to_s.should    == "/users/10/comments/new"
    request("/users/10/comments/9/edit").body.to_s.should == "/users/10/comments/9/edit"
  end
end

describe Merb::Controller, "absolute_url" do
  before do
    Merb::Router.prepare do |r|
      identify :to_param do
        r.resources :monkeys do |m|
          m.resources :blues do |b|
            b.resources :pinks
          end
        end
        r.resources :donkeys do |d|
          d.resources :blues
        end
        r.resource :red do |red|
          red.resources :blues
        end
        r.match(%r{/foo/(\d+)/}).to(:controller => 'asdf').name(:regexp)
        r.match('/people(/:name)(.:format)').to(:controller => 'people', :action => 'show').name(:person)
        r.match('/argstrs').to(:controller => "args").name(:args)
        r.default_routes
      end
    end
    
    @controller = dispatch_to(Merb::Test::Fixtures::Controllers::Url, :index)
  end

  it 'takes :protocol option' do
    @monkey = Monkey.new
    @controller.absolute_url(:monkey,
                             :id       => @monkey,
                             :format   => :xml,
                             :protocol => "https").should == "https://localhost/monkeys/45.xml"
  end

  it 'takes :host option' do
    @monkey = Monkey.new
    @controller.absolute_url(:monkey,
                             :id       => @monkey,
                             :format   => :xml,
                             :protocol => "https",
                             :host     => "rubyisnotrails.org").should == "https://rubyisnotrails.org/monkeys/45.xml"
  end

  it 'falls back to request protocol' do
    @monkey = Monkey.new
    @controller.absolute_url(:monkey,
                             :id       => @monkey,
                             :format   => :xml).should == "http://localhost/monkeys/45.xml"
  end

  it 'falls back to request host' do
    @monkey = Monkey.new
    @controller.absolute_url(:monkey,
                             :id       => @monkey,
                             :format   => :xml,
                             :protocol => "https").should == "https://localhost/monkeys/45.xml"
  end
  
  it "allows passing an object instead of a hash" do
    @monkey = Monkey.new
    @controller.absolute_url(:monkey, @monkey).should == "http://localhost/monkeys/45"
  end
  
  it "should support non-named routes" do
    @controller.absolute_url(:controller => "monkeys", :action => "list").
      should eql("http://localhost/monkeys/list")
  end
  
end
