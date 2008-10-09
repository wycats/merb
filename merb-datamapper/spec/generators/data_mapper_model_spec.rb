require File.join(File.dirname(__FILE__), 'spec_helper')
describe "Merb::Generators::ModelGenerator for DataMapper" do
  it "complains if no name is specified" do
    lambda {
      @generator = Merb::Generators::ModelGenerator.new('/tmp', {:orm => :datamapper})
    }.should raise_error(::Templater::TooFewArgumentsError)
  end


  before do
    @generator = Merb::Generators::ModelGenerator.new('/tmp',{:orm => :datamapper}, 'Stuff')
  end

  it_should_behave_like "namespaced generator"

  it "should create a model" do
    @generator.should create('/tmp/app/models/stuff.rb')
  end

  it "should render successfully" do
    lambda { @generator.render! }.should_not raise_error
  end

  it "generates a resource" do
    model_file = @generator.render!.detect { |file| file =~ /class/ }
    model_file.should match(/include DataMapper::Resource/)
  end
  it "generates a resource with appropriate properties" do
    @generator = Merb::Generators::ModelGenerator.new('/tmp',{:orm => :datamapper}, 'Stuff', 'id' => 'serial')
    model_file = @generator.template(:model_datamapper).render
    model_file.should match(/property :id, Serial/)
  end
  it "generates a resource with DateTime properties in the correct case when called with the common argument of datetime" do
    @generator = Merb::Generators::ModelGenerator.new('/tmp',{:orm => :datamapper}, 'Stuff', 'created_at' => 'datetime')
    model_file = @generator.template(:model_datamapper).render
    model_file.should match(/property :created_at, DateTime/)
  end
end
