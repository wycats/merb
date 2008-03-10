## THESE ARE CRUCIAL
module Merb
  # Set this to the version of merb-core that you are building against/for
  VERSION = "0.9.1"

  # Set this to the version of merb-more you plan to release
  MORE_VERSION = "0.9.1"
end

require "rake/clean"
require "rake/gempackagetask"
require 'fileutils'
include FileUtils

gems = %w[
  merb-action-args merb-assets merb-gen merb-haml
  merb-builder merb-mailer merb-parts
]

merb_more_spec = Gem::Specification.new do |s|
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
end

CLEAN.include ["**/.*.sw?", "pkg", "lib/*.bundle", "*.gem", "doc/rdoc", ".config", "coverage", "cache", "lib/merb-more.rb"]

windows = (PLATFORM =~ /win32|cygwin/) rescue nil

SUDO = windows ? "" : "sudo"

# desc "Installs Merb More."
# task :default => :install

Rake::GemPackageTask.new(merb_more_spec) do |package|
  package.gem_spec = merb_more_spec
end

Rake::GemPackageTask.new(merb_spec) do |package|
  package.gem_spec = merb_spec
end

desc "Install it all"
task :install => [:install_gems, :package] do
  sh %{#{SUDO} gem install --local pkg/merb-more-#{Merb::MORE_VERSION}.gem}
  sh %{#{SUDO} gem install --local pkg/merb-#{Merb::MORE_VERSION}.gem}
end

desc "Build the merb-more gems"
task :build_gems do
  gems.each do |dir|
    sh %{cd #{dir}; rake package}
  end
end

desc "Install the merb-more sub-gems"
task :install_gems do
  gems.each do |dir|
    sh %{cd #{dir}; #{SUDO} rake install}
  end
end

desc "Uninstall the merb-more sub-gems"
task :uninstall_gems do
  gems.each do |sub_gem|
    sh %{#{SUDO} gem uninstall #{sub_gem}}
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
    File.open("#{gem}/Rakefile") do |rakefile|
      rakefile.read.detect {|l| l =~ /^VERSION\s*=\s*"(.*)"$/ }
      sh %{cp #{gem}/pkg/#{gem}-#{$1}.gem bundle/}
    end
  end
end
