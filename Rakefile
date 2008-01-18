require "rake/gempackagetask"

NAME = "merb-more"

spec = Gem::Specification.new do |s|
  s.name         = NAME
  s.version      = Merb::VERSION
  s.platform     = Gem::Platform::RUBY
  s.author       = "Ezra Zygmuntowicz"
  s.email        = "ez@engineyard.com"
  s.homepage     = "http://www.merbivore.com"
  s.summary      = "Merb == Mongrel + Erb. Pocket rocket web framework."
  s.description  = s.summary
  s.require_path = "lib"
  s.files        = %w( LICENSE README Rakefile TODO ) + Dir["{spec,lib}/**/*"]

  # rdoc
  s.has_rdoc         = true
  s.extra_rdoc_files = %w( README LICENSE TODO )

  # Dependencies
  s.add_dependency "merb-core"
end

Rake::GemPackageTask.new(spec) do |package|
  package.gem_spec = spec
end

desc "Run :package and install the resulting .gem"
task :install => :package do
  sh %{#{SUDO} gem install pkg/#{NAME}-#{Merb::VERSION}.gem --no-rdoc --no-ri}
end

desc "Run :clean and uninstall the .gem"
task :uninstall => :clean do
  sh %{#{SUDO} gem uninstall #{NAME}}
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