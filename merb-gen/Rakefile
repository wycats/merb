require 'rubygems'
require "merb-core"
require 'merb-core/tasks/merb_rake_helper'
require 'rake/gempackagetask'

NAME = "merb-gen"
GEM_VERSION = Merb::MORE_VERSION rescue "0.9.4"
AUTHOR = "Jonas Nicklas"
EMAIL = "jonas.nicklas@gmail.com"
HOMEPAGE = "http://www.merbivore.com"
SUMMARY = "Merb gen: generators suite for Merb."

spec = Gem::Specification.new do |s|
  s.rubyforge_project = 'merb'
  s.name = NAME
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README", "LICENSE", 'TODO']
  s.summary = SUMMARY
  s.description = s.summary
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
  s.bindir = "bin"
  s.executables = %w( merb-gen )

  s.add_dependency "merb-core", ">= 0.9.4"
  s.add_dependency "templater", ">= 0.1.2"

  s.require_path = 'lib'
  s.autorequire = NAME
  s.files = %w(LICENSE README Rakefile TODO) + Dir.glob("{lib,bin,spec,templates}/**/*")
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

task :install => [:package] do
  sh %{#{sudo} gem install #{install_home} pkg/#{NAME}-#{GEM_VERSION} --no-update-sources}
end

namespace :jruby do
  task :install do
    sh %{#{sudo} jruby -S gem install #{install_home} pkg/#{NAME}-#{GEM_VERSION}.gem --no-rdoc --no-ri}
  end
end


##############################################################################
# Release
##############################################################################
RUBY_FORGE_PROJECT = NAME

PKG_NAME      = NAME
PKG_BUILD     = ENV['PKG_BUILD'] ? '.' + ENV['PKG_BUILD'] : ''
PKG_VERSION   = GEM_VERSION + PKG_BUILD
PKG_FILE_NAME = "#{PKG_NAME}-#{PKG_VERSION}"

RELEASE_NAME  = "REL #{PKG_VERSION}"

# FIXME: hey, someone take care of me
RUBY_FORGE_USER    = ""

require "extlib/tasks/release"
