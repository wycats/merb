require File.dirname(__FILE__) + '/spec_helper'

describe "A Merb PartController" do
  
  before(:each) do
    Merb::Router.prepare do |r|
      r.default_routes
    end
  end  
  
  it "should render a part template with no layout" do
    controller = dispatch_to(Main, :index2)
    controller.body.should ==
      "TODOPART\nDo this|Do that|Do the other thing\nTODOPART"
  end
  
  it "should render a part template with it's own layout" do
    controller = dispatch_to(Main, :index)
    controller.body.should ==
      "TODOLAYOUT\nTODOPART\nDo this|Do that|Do the other thing\nTODOPART\nTODOLAYOUT"
  end 
  
  it "should render multiple parts if more then one part is passed in" do
    controller = dispatch_to(Main, :index3)
    controller.body.should ==
      "TODOPART\nDo this|Do that|Do the other thing\nTODOPART" +
      "TODOLAYOUT\nTODOPART\nDo this|Do that|Do the other thing\nTODOPART\nTODOLAYOUT"
  end 
  
  it "should render the html format by default to the controller that set it" do
    controller = dispatch_to(Main, :index4)
    controller.body.should match(/part_html_format/m)
  end
  
  it "should render the xml format according to the controller" do
    controller = dispatch_to(Main, :index4, {:format => 'xml'} )
    controller.body.should match(/part_xml_format/m)
  end
  
  it "should render the js format according to the controller" do
    controller = dispatch_to(Main, :index4, :format => 'js')
    controller.body.should match(/part_js_format/m)
  end
  
  it "should provide params when calling a part" do
    controller = dispatch_to(Main, :part_with_params)
    controller.body.should match( /my_param = my_value/)
  end
  
  it "should render from inside a view" do
    controller = dispatch_to(Main, :part_within_view)
    controller.body.should match( /Do this/)
  end
  
  it "should render a template from an absolute path" do
    controller = dispatch_to(Main, :parth_with_absolute_template)
    controller.body.should match(/part_html_format/m)
  end
  
end  

describe "A Merb Part Controller with urls" do
   
  def new_url_controller(route, params = {:action => 'show', :controller => 'Test'})    
    @controller = dispatch_to(Main, :index)
    TodoPart.new(@controller)
  end
  
  it "should use the web_controllers type if no controller is specified" do
    c = new_url_controller(@default_route, :controller => "my_controller")
    the_url = c.url(:action => "bar")
    the_url.should == "/main/bar"
  end

end

describe "A Merb Part Controller inheriting from another Part Controller" do
  
  it "should inherit the _template_root" do
    TodoPart._template_root.should == File.expand_path(File.dirname(__FILE__) / 'fixtures' / 'parts' / 'views')
    TodoPart._template_root.should == DonePart._template_root
  end
  
end