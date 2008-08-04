$TESTING=true
$:.push File.join(File.dirname(__FILE__), '..', 'lib')

require 'rubygems'
require 'spec'
require 'merb-core'
require 'merb-gen'

shared_examples_for "named generator" do

  describe '#file_name' do
  
    it "should convert the name to snake case" do
      @generator.name = 'SomeMoreStuff'
      @generator.file_name.should == 'some_more_stuff'
    end
  
  end

  describe '#class_name' do
  
    it "should convert the name to camel case" do
      @generator.name = 'some_more_stuff'
      @generator.class_name.should == 'SomeMoreStuff'
    end
  
  end
  
  describe '#test_class_name' do
    
    it "should convert the name to camel case and append 'test'" do
      @generator.name = 'some_more_stuff'
      @generator.test_class_name.should == 'SomeMoreStuffTest'
    end
    
  end

end

shared_examples_for "chunky generator" do

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
  
  describe "#full_class_name" do
    it "should camelize the name" do
      @generator.name = "project_pictures"
      @generator.full_class_name.should == "ProjectPictures"
    end
    
    it "should leave double colon separated chunks" do
      @generator.name = "Test::Monkey::ProjectPictures"
      @generator.full_class_name.should == "Test::Monkey::ProjectPictures"
    end
    
    it "should convert slashes to double colons and camel case" do
      @generator.name = "test/monkey/project_pictures"
      @generator.full_class_name.should == "Test::Monkey::ProjectPictures"
    end
  end
  
  describe "#base_path" do
    it "should be blank for no namespaces" do
      @generator.name = "project_pictures"
      @generator.base_path.should == ""
    end
    
    it "should snakify and join namespace for double colon separated chunk" do
      @generator.name = "Test::Monkey::ProjectPictures"
      @generator.base_path.should == "test/monkey"
    end
    
    it "should leave slashes but only use the namespace part" do
      @generator.name = "test/monkey/project_pictures"
      @generator.base_path.should == "test/monkey"
    end
  end

end

class InvokeMatcher
  def initialize(expected)
    @expected = expected
  end

  def matches?(actual)
    @actual = actual
    # Satisfy expectation here. Return false or raise an error if it's not met.
    found = nil
    @actual.invocations.each { |i| found = i if i.class == @expected }
    
    if @with
      return found && (@with == found.arguments)
    else
      return found
    end
  end
  
  def with(*arguments)
    @with = arguments
    return self
  end

  def failure_message
    "expected #{@actual.inspect} to invoke #{@expected.inspect} with #{@with}, but it didn't"
  end

  def negative_failure_message
    "expected #{@actual.inspect} not to invoke #{@expected.inspect} with #{@with}, but it did"
  end
end

def invoke(expected)
  InvokeMatcher.new(expected)
end

class CreateMatcher
  def initialize(expected)
    @expected = expected
  end

  def matches?(actual)
    @actual = actual
    # Satisfy expectation here. Return false or raise an error if it's not met.
    @actual.actions.map{|t| t.destination }.include?(@expected)
  end

  def failure_message
    "expected #{@actual.inspect} to create #{@expected.inspect}, but it didn't"
  end

  def negative_failure_message
    "expected #{@actual.inspect} not to create #{@expected.inspect}, but it did"
  end
end

def create(expected)
  CreateMatcher.new(expected)
end