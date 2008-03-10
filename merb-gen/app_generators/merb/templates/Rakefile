require 'rubygems'
Gem.clear_paths
Gem.path.unshift(File.join(File.dirname(__FILE__), "gems"))

require 'rake'
require 'rake/rdoctask'
require 'rake/testtask'
require 'spec/rake/spectask'
require 'fileutils'
require 'merb-core'
require 'rubigen'
include FileUtils

# Load the basic runtime dependencies; this will include 
# any plugins and therefore plugin rake tasks.
init_env = ENV['MERB_ENV'] || 'development'
log_file = Merb.log_path / 'rake.log' 
Merb.load_dependencies(:environment => init_env)
     
# Get Merb plugins and dependencies
Merb::Plugins.rakefiles.each { |r| require r } 

desc "start runner environment"
task :merb_env do
  Merb.start_environment(:adapter => 'runner', :environment => init_env, :log_file => log_file)
end

##############################################################################
# ADD YOUR CUSTOM TASKS BELOW
##############################################################################
