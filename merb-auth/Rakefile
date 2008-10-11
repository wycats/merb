GEM_VERSION = "0.9.9"
GEM_NAME    = "merb-auth"
require "rake/clean"
require "rake/gempackagetask"
require 'rubygems/specification'
require "spec/rake/spectask"
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
  s.files = %w(LICENSE README.textile Rakefile TODO) + Dir.glob("{lib,spec}/**/*")
  s.add_dependency "merb-core", "~> #{GEM_VERSION}"
  gems.each do |gem|
    s.add_dependency gem, "~> #{GEM_VERSION}"
  end
end

CLEAN.include ["**/.*.sw?", "pkg", "lib/*.bundle", "*.gem", "doc/rdoc", ".config", "coverage", "cache"]

Rake::GemPackageTask.new(merb_auth_spec) do |package|
  package.gem_spec = merb_auth_spec
end

task :package => ["lib/merb-auth.rb"]
desc "Create merb-auth.rb"
task "lib/merb-auth.rb" do
  mkdir_p "lib"
  File.open("lib/merb-auth.rb","w+") do |file|
    file.puts "### AUTOMATICALLY GENERATED. DO NOT EDIT!"
    gems.each do |gem|
      next if gem == "merb-gen"
      file.puts "require '#{gem}'"
    end
    file.puts
    file.puts "path = File.join(File.dirname(__FILE__), \"merb-auth\")"
    file.puts "require \"#\{path\}/customizations.rb\""
    file.puts "require \"#\{path\}/router_helper.rb\""
  end
end

desc "install the plugin as a gem"
task :install do
  Merb::RakeHelper.install(GEM_NAME, :version => GEM_VERSION)
end

desc "Uninstall the gem"
task :uninstall do
  Merb::RakeHelper.uninstall(GEM_NAME, :version => GEM_VERSION)
end

desc "Create a gemspec file"
task :gemspec do
  File.open("#{GEM_NAME}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end
