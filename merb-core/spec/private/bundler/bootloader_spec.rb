require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

# Load Bundler and it's environment
require 'bundler'
require File.expand_path(File.dirname(__FILE__) + '/fixture/vendor/gems/environment')

# When we're not bundled?
#module Bundler
#  @gemfile = File.expand_path(File.dirname(__FILE__) + '/fixture/Gemfile')
#end
#require 'bundler/runtime'

module BootLoaderSpecHelper
  def merb_options
    { :verbose   => true,
      :log_level => :debug,
      :merb_root => File.expand_path(File.dirname(__FILE__) + '/fixture') }
  end
end

describe Merb::BootLoader::Dependencies do
  include BootLoaderSpecHelper
  
  it "should load bundled gems" do
    startup_merb(merb_options)
    lambda { Sequel.version }.should_not raise_error
  end
end
