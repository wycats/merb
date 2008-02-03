require "rake/gempackagetask"
require "merb-core"
NAME = "merb-more"

spec = Gem::Specification.new do |s|
  s.name         = NAME
  s.version      = Merb::VERSION
  s.platform     = Gem::Platform::RUBY
  s.author       = "Ezra Zygmuntowicz"
  s.email        = "ez@engineyard.com"
  s.homepage     = "http://www.merbivore.com"
  s.summary      = "Adds a 'new merb project' generator and mailer plugin to merb-core."
  s.description  = s.summary
  #s.require_path = "lib"
  #s.files        = %w( LICENSE README Rakefile TODO ) + Dir["{spec,lib}/**/*"]

  # rdoc
  #s.has_rdoc         = true
  #s.extra_rdoc_files = %w( README LICENSE TODO )

  # Dependencies
  s.add_dependency "merb-core"
end

windows = (PLATFORM =~ /win32|cygwin/) rescue nil

SUDO = windows ? "" : "sudo"
sub_gems = %w(merb-gen merb-mailer)

desc "Installs Merb More."
task :default => :install

Rake::GemPackageTask.new(spec) do |package|
  package.gem_spec = spec
end

desc "Install the merb-more sub-gems"
task :install do
  sub_gems.each do |dir|
    sh %{cd #{dir}; #{SUDO} rake install}
  end
end

desc "Uninstall the merb-more sub-gems"
task :uninstall do
  sub_gems.each do |sub_gem|
    sh %{#{SUDO} gem uninstall #{sub_gem}}
  end
end

# SPECS
desc "Run all specs"
task :specs do
  examples, failures, pending = 0, 0, 0
  Dir["spec/**/*_spec.rb"].each do |spec|
    response = `spec #{File.expand_path(spec)} -f s -c`
    e, f, p = response.match(/(\d+) examples?, (\d+) failures?(?:, (\d+) pending?)?/)[1..-1]
    examples += e.to_i; failures += f.to_i; pending += p.to_i
    puts response
  end
  puts "\n*** TOTALS ***"
  puts "#{examples} examples, #{failures} failures#{ ", #{pending} pending" if pending}"
end