# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{extlib}
  s.version = "0.9.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sam Smoot"]
  s.date = %q{2008-10-12}
  s.description = %q{Support library for DataMapper and Merb.}
  s.email = %q{ssmoot@gmail.com}
  s.extra_rdoc_files = ["LICENSE", "README.txt"]
  s.files = ["LICENSE", "README.txt", "Rakefile", "lib/extlib.rb", "lib/extlib", "lib/extlib/dictionary.rb", "lib/extlib/lazy_array.rb", "lib/extlib/nil.rb", "lib/extlib/class.rb", "lib/extlib/rubygems.rb", "lib/extlib/module.rb", "lib/extlib/string.rb", "lib/extlib/hook.rb", "lib/extlib/blank.rb", "lib/extlib/logger.rb", "lib/extlib/datetime.rb", "lib/extlib/assertions.rb", "lib/extlib/inflection.rb", "lib/extlib/pathname.rb", "lib/extlib/object_space.rb", "lib/extlib/mash.rb", "lib/extlib/virtual_file.rb", "lib/extlib/simple_set.rb", "lib/extlib/object.rb", "lib/extlib/hash.rb", "lib/extlib/version.rb", "lib/extlib/boolean.rb", "lib/extlib/symbol.rb", "lib/extlib/numeric.rb", "lib/extlib/struct.rb", "lib/extlib/pooling.rb", "lib/extlib/tasks", "lib/extlib/tasks/release.rb", "lib/extlib/time.rb"]
  s.homepage = %q{http://extlib.rubyforge.org}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Support library for DataMapper and Merb.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
