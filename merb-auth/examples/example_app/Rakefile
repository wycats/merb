require 'rubygems'
Gem.clear_paths
Gem.path.unshift(File.join(File.dirname(__FILE__), "gems"))

require 'rake'
require 'rake/rdoctask'
require 'rake/testtask'
require 'spec/rake/spectask'
require 'fileutils'

##
# requires frozen merb-core (from /framework)
# adds the other components to the load path
def require_frozen_framework
  framework = File.join(File.dirname(__FILE__), "framework")
  if File.directory?(framework)
    puts "Running from frozen framework"
    core = File.join(framework,"merb-core")
    if File.directory?(core)
      puts "using merb-core from #{core}"
      $:.unshift File.join(core,"lib")
      require 'merb-core'
    end
    more = File.join(framework,"merb-more")
    if File.directory?(more)
      Dir.new(more).select {|d| d =~ /merb-/}.each do |d|
        $:.unshift File.join(more,d,'lib')
      end
    end
    plugins = File.join(framework,"merb-plugins")
    if File.directory?(plugins)
      Dir.new(plugins).select {|d| d =~ /merb_/}.each do |d|
        $:.unshift File.join(plugins,d,'lib')
      end
    end
    require "merb-core/core_ext/kernel"
    require "merb-core/core_ext/rubygems"
  else
    p "merb doesn't seem to be frozen in /framework"
    require 'merb-core'
  end
end

if ENV['FROZEN']
  require_frozen_framework
else
  require 'merb-core'
end

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
