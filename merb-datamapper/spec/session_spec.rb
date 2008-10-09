# Specs kindly provided by Fabien Franzen
$:.push File.join(File.dirname(__FILE__), '..', 'lib')
require 'merb-core'
require 'merb-core/test'
require 'merb-core/test/helpers'

Merb::BootLoader.before_app_loads do
  require 'merb_datamapper'
  require 'merb/session/data_mapper_session'
  DataMapper.setup(:default, 'sqlite3::memory:')
  repository(:default).auto_migrate!
end

Merb.start_environment(:environment => 'test', :adapter => 'runner',
                       :session_store => 'datamapper')

Spec::Runner.configure do |config|
  config.include Merb::Test::RequestHelper
end

# Load up the shared specs from merb-core
if (gem_spec = Gem.source_index.search(Gem::Dependency.new('merb-core', '>=0.9.6')).last) &&
  gem_spec.files.include?('spec/public/session/controllers/sessions.rb')
  require gem_spec.full_gem_path / 'spec/public/session/controllers/sessions.rb'
  require gem_spec.full_gem_path / 'spec/public/session/session_spec.rb'
end

describe Merb::DataMapperSession do

  before do
    @session_class = Merb::DataMapperSession
    @session = @session_class.generate
  end

#  it_should_behave_like "All session-store backends"

  it "should have a session_store_type class attribute" do
    @session.class.session_store_type.should == :datamapper
  end

end

describe Merb::DataMapperSession, "mixed into Merb::Controller" do

  before(:all) { @session_class = Merb::DataMapperSession }

#  it_should_behave_like "All session-stores mixed into Merb::Controller"

end
