require 'rubygems'

# Figure out the merb root - defaults to the current directory.
__DIR__ = ENV['MERB_ROOT'] || Dir.getwd

# Piggyback on the merb-core rubygem for initial setup scripts.
# Requiring it doesn't affect the local gem version of merb-core
# we might effectively want to load here after. 
if merb_core_dir = Dir[File.join(__DIR__, 'gems', 'gems', 'merb-core-*')].last
  require File.join(merb_core_dir, 'lib', 'merb-core', 'script')
else
  require 'merb-core/script'
end

# Include some script helper methods.
include Merb::ScriptHelpers

# Now setup local gems to be incorporated into the normal loaded gems.
setup_local_gems!(__DIR__)

# When running rake tasks, you can disable local gems using NO_FROZEN:
# rake NO_FROZEN=true -T # see all rake tasks, loaded from system gems.

require 'rake'
require 'rake/rdoctask'
require 'rake/testtask'
require 'spec/rake/spectask'
require 'fileutils'

# Require the *real* merb-core, which is the local version for a frozen setup.
require "merb-core"

require 'merb-core/tasks/merb'
include FileUtils

# Load the basic runtime dependencies; this will include 
# any plugins and therefore plugin rake tasks.
init_env = ENV['MERB_ENV'] || 'rake'
Merb.load_dependencies(:environment => init_env)
     
# Get Merb plugins and dependencies
Merb::Plugins.rakefiles.each { |r| require r } 

# Load any app level custom rakefile extensions from lib/tasks
tasks_path = File.join(File.dirname(__FILE__), "lib", "tasks")
rake_files = Dir["#{tasks_path}/*.rake"]
rake_files.each{|rake_file| load rake_file }

desc "start runner environment"
task :merb_env do
  Merb.start_environment(:environment => init_env, :adapter => 'runner')
end

##############################################################################
# ADD YOUR CUSTOM TASKS IN /lib/tasks
# NAME YOUR RAKE FILES file_name.rake
##############################################################################
