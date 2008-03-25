require 'rubygems'
require 'rake/gempackagetask'

GEM = "merb-gen"
VERSION = "0.9.2"
AUTHOR = "Yehuda Katz"
EMAIL = "wycats@gmail.com"
HOMEPAGE = "http://www.merbivore.com"
SUMMARY = "Merb More: Merb's Application and Plugin Generators"

spec = Gem::Specification.new do |s|
  s.name = GEM
  s.version = VERSION
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
    
  # Uncomment this to add a dependency
  s.add_dependency "merb-core", ">= 0.9.2"
  s.add_dependency "rubigen", ">= 1.2.4"
  
  s.require_path = 'lib'
  s.autorequire = GEM
  s.files = %w(LICENSE README Rakefile TODO) + 
          Dir.glob("{lib,bin,spec,app_generators,merb_default_generators,merb_generators,rspec_generators,test_unit_generators}/**/*")
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

namespace :jruby do
  task :install do
    sh %{sudo jruby -S gem install pkg/#{GEM}-#{VERSION} --no-update-sources}
  end
end

task :install => [:package] do
  sh %{sudo gem install pkg/#{GEM}-#{VERSION} --no-update-sources}
end
