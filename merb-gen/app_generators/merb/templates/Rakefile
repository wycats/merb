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
init_env = ENV['MERB_ENV'] || 'rake'
Merb.load_dependencies(:environment => init_env)

# Uncomment the line below if you'd like to load in tasks defined in lib/merb-core/tasks
# require 'merb-core/tasks/merb'
     
# Get Merb plugins and dependencies
Merb::Plugins.rakefiles.each { |r| require r } 

# Get Merb custom rake tasks from lib/tasks
tasks_path = File.join(File.dirname(__FILE__), "lib", "tasks")
rake_files = Dir["#{tasks_path}/*.rb"]
rake_files.each{|rake_file| require rake_file }

desc "start runner environment"
task :merb_env do
  Merb.start_environment(:environment => init_env, :adapter => 'runner')
end

##############################################################################
# ADD YOUR CUSTOM TASKS BELOW
# OR IN /lib/tasks
# CALL YOUR RAKE FILES file_name.rb
##############################################################################
