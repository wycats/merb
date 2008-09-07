## THESE ARE CRUCIAL
module Merb
  # Set this to the version of merb-core that you are building against/for
  VERSION = "0.9.6"

  # Set this to the version of merb-more you plan to release
  MORE_VERSION = "0.9.6"
end

GEM_VERSION = Merb::VERSION

require "rake/clean"
require "rake/gempackagetask"
require 'merb-core/tasks/merb_rake_helper'
require 'fileutils'
include FileUtils

gems = %w[
  merb-action-args merb-assets merb-gen merb-haml
  merb-builder merb-mailer merb-parts merb-cache merb-slices merb-jquery
]

merb_more_spec = Gem::Specification.new do |s|
  s.rubyforge_project = 'merb'
  s.name         = "merb-more"
  s.version      = Merb::MORE_VERSION
  s.platform     = Gem::Platform::RUBY
  s.author       = "Ezra Zygmuntowicz"
  s.email        = "ez@engineyard.com"
  s.homepage     = "http://www.merbivore.com"
  s.summary      = "(merb - merb-core) == merb-more.  The Full Stack. Take what you need; leave what you don't."
  s.description  = s.summary
  s.files        = %w( LICENSE README Rakefile TODO lib/merb-more.rb )
  s.add_dependency "merb-core", ">= #{Merb::VERSION}"
  gems.each do |gem|
    s.add_dependency gem, [">= #{Merb::VERSION}", "<= 1.0"]
  end
end

merb_spec = Gem::Specification.new do |s|
  s.rubyforge_project = 'merb'
  s.name         = "merb"
  s.version      = Merb::MORE_VERSION
  s.platform     = Gem::Platform::RUBY
  s.author       = "Ezra Zygmuntowicz"
  s.email        = "ez@engineyard.com"
  s.homepage     = "http://www.merbivore.com"
  s.summary      = "(merb-core + merb-more) == all of Merb"
  s.description  = s.summary
  s.files        = %w( LICENSE README Rakefile TODO )
  s.add_dependency "merb-core", "= #{Merb::VERSION}"
  s.add_dependency "merb-more", "= #{Merb::MORE_VERSION}"
  s.add_dependency "mongrel", ">= 1.0.1"
end

CLEAN.include ["**/.*.sw?", "pkg", "lib/*.bundle", "*.gem", "doc/rdoc", ".config", "coverage", "cache", "lib/merb-more.rb"]

Rake::GemPackageTask.new(merb_more_spec) do |package|
  package.gem_spec = merb_more_spec
end

Rake::GemPackageTask.new(merb_spec) do |package|
  package.gem_spec = merb_spec
end

gem_home = ENV['GEM_HOME'] ? "GEM_HOME=#{ENV['GEM_HOME']}" : ""
desc "Install it all"
task :install => [:install_gems, :package] do
  sh %{#{sudo} gem install #{install_home} --local pkg/merb-more-#{Merb::MORE_VERSION}.gem  --no-update-sources}
  sh %{#{sudo} gem install #{install_home} --local pkg/merb-#{Merb::MORE_VERSION}.gem --no-update-sources}
end

desc "Build the merb-more gems"
task :build_gems do
  gems.each do |dir|
    Dir.chdir(dir){ sh "rake package" }
  end
end

desc "Install the merb-more sub-gems"
task :install_gems do
  gems.each do |dir|
    Dir.chdir(dir){ sh "rake install" }
  end
end

desc "Uninstall the merb-more sub-gems"
task :uninstall_gems do
  gems.each do |sub_gem|
    sh %{#{sudo} gem uninstall #{sub_gem}}
  end
end

desc "Clobber the merb-more sub-gems"
task :clobber_gems do
  gems.each do |gem|
    Dir.chdir(gem){ sh "rake clobber" }
  end
end


task :package => ["lib/merb-more.rb"]
desc "Create merb-more.rb"
task "lib/merb-more.rb" do
  mkdir_p "lib"
  File.open("lib/merb-more.rb","w+") do |file|
    file.puts "### AUTOMATICALLY GENERATED.  DO NOT EDIT."
    gems.each do |gem|
      next if gem == "merb-gen"
      file.puts "require '#{gem}'"
    end
  end
end

desc "Bundle up all the merb-more gems"
task :bundle => [:package, :build_gems] do
  mkdir_p "bundle"
  cp "pkg/merb-#{Merb::MORE_VERSION}.gem", "bundle"
  cp "pkg/merb-more-#{Merb::MORE_VERSION}.gem", "bundle"
  gems.each do |gem|
    sh %{cp #{gem}/pkg/#{gem}-#{Merb::MORE_VERSION}.gem bundle/}
  end
end


RUBY_FORGE_PROJECT = "merb"

GROUP_NAME    = "merb"
PKG_BUILD     = ENV['PKG_BUILD'] ? '.' + ENV['PKG_BUILD'] : ''
PKG_VERSION   = GEM_VERSION + PKG_BUILD

RELEASE_NAME  = "REL #{PKG_VERSION}"

namespace :release do
  desc "Publish Merb More release files to RubyForge."
  task :merb_more => [ :package ] do
    require 'rubyforge'
    require 'rake/contrib/rubyforgepublisher'

    packages = %w( gem tgz zip ).collect{ |ext| "pkg/merb-more-#{PKG_VERSION}.#{ext}" }

    begin
      sh %{rubyforge login}
      sh %{rubyforge add_release #{RUBY_FORGE_PROJECT} merb-more #{Merb::MORE_VERSION} #{packages.join(' ')}}
      sh %{rubyforge add_file #{RUBY_FORGE_PROJECT} merb-more #{Merb::MORE_VERSION} #{packages.join(' ')}}
    rescue Exception => e
      puts
      puts "Release failed: #{e.message}"
      puts
      puts "Set PKG_BUILD environment variable if you do a subrelease (0.9.4.2008_08_02 when version is 0.9.4)"
    end
  end

  desc "Publish Merb More gem to RubyForge, one by one."
  task :merb_more_gems => [ :build_gems ] do
    gems.each do |gem|
      Dir.chdir(gem){ sh "rake release" }
    end
  end


  desc "Publish Merb release files to RubyForge."
  task :merb => [ :package ] do
    require 'rubyforge'
    require 'rake/contrib/rubyforgepublisher'

    packages = %w( gem tgz zip ).collect{ |ext| "pkg/merb-#{PKG_VERSION}.#{ext}" }

    begin
      sh %{rubyforge login}
      sh %{rubyforge add_release #{RUBY_FORGE_PROJECT} merb #{Merb::VERSION} #{packages.join(' ')}}
      sh %{rubyforge add_file #{RUBY_FORGE_PROJECT} merb #{Merb::VERSION} #{packages.join(' ')}}
    rescue Exception => e
      puts
      puts "Release failed: #{e.message}"
      puts
      puts "Set PKG_BUILD environment variable if you do a subrelease (0.9.4.2008_08_02 when version is 0.9.4)"
    end
  end
end

