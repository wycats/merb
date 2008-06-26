require File.dirname(__FILE__) + '/spec_helper'

describe Merb::Generators::ModelGenerator do
  
  before do
    @generator = Merb::Generators::MigrationGenerator.new('/tmp', {}, 'SomeMoreStuff')
  end
  
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
  
  describe '#version' do
    it "should find the current migration version and increase it by one" do
      @previous_migration_files = [
        "/tmp/schema/migrations/001_monkey.rb",
        "/tmp/schema/migrations/002_blah.rb",
        "/tmp/schema/migrations/005_gurr_blah.rb",
        "/tmp/schema/migrations/006_garr.rb"
      ]
      Dir.should_receive(:[]).with('/tmp/schema/migrations/*').and_return(@previous_migration_files)
      
      @generator.version.should == "007"
    end
    
    it "should be 1 if there are no previous migrations" do
      Dir.should_receive(:[]).with('/tmp/schema/migrations/*').and_return([])
      
      @generator.version.should == "001"
    end
  end
  
end