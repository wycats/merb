require 'rubygems'
require 'rake/gempackagetask'
require "extlib"
require 'merb-core/tasks/merb_rake_helper'
require "spec/rake/spectask"

##############################################################################
# Package && release
##############################################################################
RUBY_FORGE_PROJECT  = "merb"
PROJECT_URL         = "http://merbivore.com"
PROJECT_SUMMARY     = "Generators suite for Merb."
PROJECT_DESCRIPTION = PROJECT_SUMMARY

GEM_AUTHOR = "Jonas Nicklas"
GEM_EMAIL  = "jonas.nicklas@gmail.com"

GEM_NAME    = "merb-gen"
PKG_BUILD   = ENV['PKG_BUILD'] ? '.' + ENV['PKG_BUILD'] : ''
GEM_VERSION = (Merb::MORE_VERSION rescue "0.9.6") + PKG_BUILD

RELEASE_NAME    = "REL #{GEM_VERSION}"

require "extlib/tasks/release"

spec = Gem::Specification.new do |s|
  s.rubyforge_project = RUBY_FORGE_PROJECT
  s.name = GEM_NAME
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README", "LICENSE", 'TODO']
  s.summary = PROJECT_SUMMARY
  s.description = PROJECT_DESCRIPTION
  s.author = GEM_AUTHOR
  s.email = GEM_EMAIL
  s.homepage = PROJECT_URL
  s.bindir = "bin"
  s.executables = %w( merb-gen )

  s.add_dependency "merb-core", ">= 0.9.6"
  s.add_dependency "templater", ">= 0.2.0"

  s.require_path = 'lib'
  s.autorequire = GEM_NAME
  s.files = %w(LICENSE README Rakefile TODO) + Dir.glob("{lib,bin,spec}/**/*")
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "Install the gem"
task :install => [:package] do
  sh install_command(GEM_NAME, GEM_VERSION)
end

namespace :jruby do

  desc "Run :package and install the resulting .gem with jruby"
  task :install => :package do
    sh jinstall_command(GEM_NAME, GEM_VERSION)
  end

end
