GEM_VERSION = "0.9.9"
GEM_NAME    = "merb-auth"

require "rake/clean"
require "rake/gempackagetask"
require 'merb-core/tasks/merb_rake_helper'
require 'fileutils'
include FileUtils

gems = %w[
  merb-auth-core merb-auth-more merb-auth-slice-password
]
merb_auth_spec = Gem::Specification.new do |s|
  s.rubyforge_project = 'merb-auth'
  s.name         = GEM_NAME
  s.version      = GEM_VERSION
  s.platform     = Gem::Platform::RUBY
  s.author       = "Daniel Neighman"
  s.email        = "has.sox@gmail.com"
  s.homepage     = "http://www.merbivore.com"
  s.summary      = "merb-auth.  The official authentication plugin for merb.  Setup for the default stack"
  s.description  = s.summary
  s.files        = %w( LICENSE README.textile Rakefile TODO lib/merb-auth.rb )
  s.add_dependency "merb-core", "~> #{GEM_VERSION}"
  gems.each do |gem|
    s.add_dependency gem, "~> #{GEM_VERSION}"
  end
end

CLEAN.include ["**/.*.sw?", "pkg", "lib/*.bundle", "*.gem", "doc/rdoc", ".config", "coverage", "cache", "lib/merb-auth.rb"]

Rake::GemPackageTask.new(merb_auth_spec) do |package|
  package.gem_spec = merb_auth_spec
end

desc "Install all gems"
task :install do
  Merb::RakeHelper.install("merb-auth", :version => GEM_VERSION)
  Merb::RakeHelper.install_package("pkg/merb-auth-#{GEM_VERSION}.gem")
end

desc "Uninstall all gems"
task :uninstall => :uninstall_gems do
  Merb::RakeHelper.uninstall('merb-auth', :version => GEM_VERSION)
  Merb::RakeHelper.uninstall('merb-auth', :version => GEM_VERSION)
end

desc "Build the merb-auth gems"
task :build_gems do
  gems.each do |dir|
    Dir.chdir(dir) { sh "#{Gem.ruby} -S rake package" }
  end
end

desc "Install the merb-auth sub-gems"
task :install_gems do
  gems.each do |dir|
    Dir.chdir(dir) { sh "#{Gem.ruby} -S rake install" }
  end
end

desc "Uninstall the merb-auth sub-gems"
task :uninstall_gems do
  gems.each do |dir|
    Dir.chdir(dir) { sh "#{Gem.ruby} -S rake uninstall" }
  end
end

desc "Clobber the merb-auth sub-gems"
task :clobber_gems do
  gems.each do |dir|
    Dir.chdir(dir) { sh "#{Gem.ruby} -S rake clobber" }
  end
end

task :package => ["lib/merb-auth.rb"]
desc "Create merb-auth.rb"
task "lib/merb-auth.rb" do
  mkdir_p "lib"
  File.open("lib/merb-auth.rb","w+") do |file|
    file.puts "### AUTOMATICALLY GENERATED.  DO NOT EDIT."
    gems.each do |gem|
      file.puts "require '#{gem}'"
    end
    
  end
end

desc "Bundle up all the merb-auth gems"
task :bundle => [:package, :build_gems] do
  mkdir_p "bundle"
  cp "pkg/merb-auth-#{GEM_VERSION}.gem", "bundle"
  gems.each do |gem|
    sh %{cp #{gem}/pkg/#{gem}-#{GEM_VERSION}.gem bundle/}
  end

end