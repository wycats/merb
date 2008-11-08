# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{mime-types}
  s.version = "1.15"

  s.required_rubygems_version = nil if s.respond_to? :required_rubygems_version=
  s.authors = ["Austin Ziegler"]
  s.cert_chain = nil
  s.date = %q{2006-02-12}
  s.description = %q{This library allows for the identification of a file's likely MIME content type. This is release 1.15. The identification of MIME content type is based on a file's filename extensions.}
  s.email = %q{austin@rubyforge.org}
  s.extra_rdoc_files = ["README", "ChangeLog", "Install"]
  s.files = ["lib/mime", "lib/mime/types.rb", "tests/tc_mime_type.rb", "tests/tc_mime_types.rb", "tests/testall.rb", "ChangeLog", "README", "LICENCE", "setup.rb", "Rakefile", "pre-setup.rb", "Install"]
  s.has_rdoc = true
  s.homepage = %q{http://mime-types.rubyforge.org/}
  s.rdoc_options = ["--title", "MIME::Types", "--main", "README", "--line-numbers"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new("> 0.0.0")
  s.rubyforge_project = %q{mime-types}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Manages a MIME Content-Type that will return the Content-Type for a given filename.}
  s.test_files = ["tests/testall.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 1

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
