# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{merb-auth_password_slice}
  s.version = "0.9.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Your Name"]
  s.date = %q{2008-10-03}
  s.description = %q{Merb Slice that provides ...}
  s.email = %q{Your Email}
  s.extra_rdoc_files = ["README.textile", "LICENSE", "TODO"]
  s.files = ["LICENSE", "README.textile", "Rakefile", "TODO", "lib/merb-auth_password_slice.rb", "lib/merb-auth_password_slice", "lib/merb-auth_password_slice/merbtasks.rb", "lib/merb-auth_password_slice/slicetasks.rb", "lib/merb-auth_password_slice/spectasks.rb", "spec/controllers", "spec/controllers/main_spec.rb", "spec/merb-auth_password_slice_spec.rb", "spec/spec_helper.rb", "app/controllers", "app/controllers/application.rb", "app/controllers/exceptions.rb", "app/controllers/sessions.rb", "app/helpers", "app/helpers/application_helper.rb", "app/views", "app/views/exceptions", "app/views/exceptions/unauthenticated.html.erb", "app/views/layout", "app/views/layout/merb-auth_password_slice.html.erb", "public/javascripts", "public/javascripts/master.js", "public/stylesheets", "public/stylesheets/master.css", "stubs/app", "stubs/app/controllers", "stubs/app/controllers/application.rb", "stubs/app/controllers/main.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://merbivore.com/}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{merb}
  s.rubygems_version = %q{1.3.0}
  s.summary = %q{Merb Slice that provides ...}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<merb-auth-core>, [">= 0.1.1"])
    else
      s.add_dependency(%q<merb-auth-core>, [">= 0.1.1"])
    end
  else
    s.add_dependency(%q<merb-auth-core>, [">= 0.1.1"])
  end
end
