require File.dirname(__FILE__) + '/spec_helper'

describe Merb::Generators::ResourceControllerGenerator do

  before(:each) do
    @generator = Merb::Generators::ResourceControllerGenerator.new('/tmp', {}, 'Stuff')
  end
  
  it_should_behave_like "chunky generator"
  
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