require File.dirname(__FILE__) + '/spec_helper'

describe Merb::Generators::MerbStackGenerator do

  describe "templates" do

    before do
      @generator = Merb::Generators::MerbStackGenerator.new('/tmp', {}, 'testing')
    end

    it_should_behave_like "named generator"
    it_should_behave_like "app generator"

    it "should create an Gemfile" do
      @generator.should create('/tmp/testing/Gemfile')
    end

    it "should create a passenger config file" do
      @generator.should create('/tmp/testing/config.ru')
    end

    it "should create config/init.rb" do
      @generator.should create('/tmp/testing/config/init.rb')
    end

    it "should create config/database.yml" do
      @generator.should create('/tmp/testing/config/database.yml')
    end

    it "should have an application controller" do
      @generator.should create('/tmp/testing/app/controllers/application.rb')
    end

    it "should have an exceptions controller" do
      @generator.should create('/tmp/testing/app/controllers/exceptions.rb')
    end

    it "should have a gitignore file" do
      @generator.should create('/tmp/testing/.gitignore')
    end

    it "should create a number of views"

    it "should render templates successfully" do
      lambda do 
        @generator.render! 
      end.should_not raise_error
    end

    it "should create an empty lib/tasks directory" do
      @generator.should create('/tmp/testing/lib/tasks')
    end

  end

end
