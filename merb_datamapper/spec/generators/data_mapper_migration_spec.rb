require File.join(File.dirname(__FILE__), 'spec_helper')
# many specs copied from merb-gen master branch
describe "Merb::Generators::MigrationGenerator for DataMapper" do
  it "should complain if no name is specified" do
    lambda {
      @generator = Merb::Generators::MigrationGenerator.new('/tmp', {:orm => :datamapper})
    }.should raise_error(::Templater::TooFewArgumentsError)
  end


  describe "with no options" do
    before(:each) do
      @base_dir = "/tmp/migrations"
      FileUtils.mkdir_p @base_dir
      @generator = Merb::Generators::MigrationGenerator.new(@base_dir, {:orm => :datamapper}, 'SomeMoreStuff')
    end

    after(:each) do
      FileUtils.rm_r @base_dir
    end

    it "should render successfully" do
      lambda { @generator.render! }.should_not raise_error
    end

    it "creates the file correctly" do
      @generator.should create('/tmp/migrations/schema/migrations/001_some_more_stuff_migration.rb')
    end

  end
end
