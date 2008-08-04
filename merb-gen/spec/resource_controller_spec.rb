require File.dirname(__FILE__) + '/spec_helper'

describe Merb::Generators::ResourceControllerGenerator do

  before(:each) do
    @generator = Merb::Generators::ResourceControllerGenerator.new('/tmp', {}, 'Stuff')
  end
  
  describe "#class_name" do
    it "should camelize the name" do
      @generator.name = "project_pictures"
      @generator.class_name.should == "ProjectPictures"
    end
    
    it "should split off the last double colon separated chunk" do
      @generator.name = "Test::Monkey::ProjectPictures"
      @generator.class_name.should == "ProjectPictures"
    end
    
    it "should split off the last slash separated chunk" do
      @generator.name = "test/monkey/project_pictures"
      @generator.class_name.should == "ProjectPictures"
    end
  end
  
  describe "#modules" do
    it "should be empty if no modules are passed to the name" do
      @generator.name = "project_pictures"
      @generator.modules.should == []
    end
    
    it "should split off all but the last double colon separated chunks" do
      @generator.name = "Test::Monkey::ProjectPictures"
      @generator.modules.should == ["Test", "Monkey"]
    end
    
    it "should split off all but the last slash separated chunk" do
      @generator.name = "test/monkey/project_pictures"
      @generator.modules.should == ["Test", "Monkey"]
    end
  end
  
  describe "#file_name" do
    it "should snakify the name" do
      @generator.name = "ProjectPictures"
      @generator.file_name.should == "project_pictures"
    end
    
    it "should split off the last double colon separated chunk and snakify it" do
      @generator.name = "Test::Monkey::ProjectPictures"
      @generator.file_name.should == "project_pictures"
    end
    
    it "should split off the last slash separated chunk and snakify it" do
      @generator.name = "test/monkey/project_pictures"
      @generator.file_name.should == "project_pictures"
    end
  end
  
  describe "#test_class_name" do
    it "should camelize the name and append 'Test'" do
      @generator.name = "project_pictures"
      @generator.test_class_name.should == "ProjectPicturesTest"
    end
    
    it "should split off the last double colon separated chunk" do
      @generator.name = "Test::Monkey::ProjectPictures"
      @generator.test_class_name.should == "ProjectPicturesTest"
    end
    
    it "should split off the last slash separated chunk" do
      @generator.name = "test/monkey/project_pictures"
      @generator.test_class_name.should == "ProjectPicturesTest"
    end
  end
  
  describe "#model_class_name" do
    it "should camel case and singularize the controller name" do
      @generator.name = "project_pictures"
      @generator.model_class_name == "ProjectPicture"
    end
  end
  
  describe "#plural_model" do
    it "should snake case the controller name" do
      @generator.name = "ProjectPictures"
      @generator.plural_model == "project_pictures"
    end
  end
  
  describe "#singular_model" do
    it "should snake case and singularize the controller name" do
      @generator.name = "ProjectPictures"
      @generator.singular_model == "project_picture"
    end
  end
  
end