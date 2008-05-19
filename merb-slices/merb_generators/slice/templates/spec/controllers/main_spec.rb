describe "<%= module_name %>::Main (controller)" do
  
  # Feel free to remove the specs below
  
  it "should have an index action" do
    controller = dispatch_to(<%= module_name %>::Main, :index)
    controller.status.should == 200
    controller.body.should contain('<%= module_name %>')
  end
  
  it "should have helper methods for dealing with public paths" do
    controller = dispatch_to(<%= module_name %>::Main, :index)
    
    controller.image_path.should == controller.public_path_for(:image)
    controller.javascript_path.should == controller.public_path_for(:javascript)
    controller.stylesheet_path.should == controller.public_path_for(:stylesheet)
    
    controller.image_path.should == "/slices/<%= base_name %>/images"
    controller.javascript_path.should == "/slices/<%= base_name %>/javascripts"
    controller.stylesheet_path.should == "/slices/<%= base_name %>/stylesheets"
  end
  
end