require File.join(File.dirname(__FILE__), 'spec_helper')
describe "Merb::Generators::ResourceControllerGenerator for DataMapper" do
  it "complains if no name is specified" do
    lambda {
      @generator = Merb::Generators::ResourceControllerGenerator.new('/tmp', {:orm => :datamapper })
    }.should raise_error(::Templater::TooFewArgumentsError)
  end


  before do
    @generator = Merb::Generators::ResourceControllerGenerator.new('/tmp', { :orm => :datamapper }, 'Stuff')
  end

  it_should_behave_like "namespaced generator"

  it "should create a model" do
    @generator.should create('/tmp/app/controllers/stuff.rb')
  end

  it "should render successfully" do
    lambda { @generator.render! }.should_not raise_error
  end

end
