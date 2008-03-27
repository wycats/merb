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
     
# Get Merb plugins and dependencies
Merb::Plugins.rakefiles.each { |r| require r } 

desc "start runner environment"
task :merb_env do
  Merb.start_environment(:environment => init_env, :adapter => 'runner')
end

##############################################################################
# ADD YOUR CUSTOM TASKS BELOW
##############################################################################

desc "Add new files to subversion"
task :svn_add do
   system "svn status | grep '^\?' | sed -e 's/? *//' | sed -e 's/ /\ /g' | xargs svn add"
end


class Freezer
  
  class << self

    def components
      {
        "core" => "git://github.com/wycats/merb-core.git",
        "more" => "git://github.com/wycats/merb-more.git",
        "plugins" => "git://github.com/wycats/merb-plugins.git"
      }
    end

    def framework_dir
      # Should allow customization of this directory's location?
      File.join(File.dirname(__FILE__), "framework")
    end

    def gitmodules
      File.join(File.dirname(__FILE__), ".gitmodules")    
    end

    def freeze(component, update = false)
      new(component, update).freeze
    end

  end

  def initialize(component, update)
    @component = "merb-" + component
    @update    = update
  end
  
  def freeze
    # Ensure that required git commands are available
    %w(git-pull git-submodule).each do |bin|
      next if in_path?(bin)
      $stderr.puts "ERROR: #{bin} must be avaible in PATH"
      exit 1
    end

    unless File.directory?(framework_dir)
      puts "Creating framework directory ..."
      FileUtils.mkdir_p(framework_dir)
    end

    if managed?
      puts "#{@component} seems to be already managed by git-submodule."
      if @update
        puts "Trying to update #{@component} ..."
        sh "cd #{framework_dir}/#{@component} && git-pull"
      end
    else
      puts "Creating submodule for #{@component} ..."
      sh "git-submodule --quiet add #{components[@component.gsub("merb-", '')]} #{File.basename(framework_dir)}/#{@component}" 
      if $?.success?
        sh("git-submodule init")
      else
        # Should this instead be a raise?
        $stderr.puts("ERROR: unable to create submodule for #{@component}")
      end
    end
  end

  protected

  def in_submodule?
    return false unless File.exists?(gitmodules)
    File.read(gitmodules) =~ %r![submodule "#{framework_dir}/#{@component}"]!
  end

  def managed?
    File.directory?(File.join(framework_dir, @component)) || in_submodule?
  end

  def in_path?(bin)
    `which #{bin}`
    !$?.nil? && $?.success?
  end

end

task :freeze => Freezer.components.keys.map { |component| "freeze:#{component}" }
namespace :freeze do
  Freezer.components.each do |component, git_repository|
    desc "Freeze #{component} from #{git_repository}"
    task component do
      Freezer.freeze(component, ENV["UPDATE"])
    end
  end
end
