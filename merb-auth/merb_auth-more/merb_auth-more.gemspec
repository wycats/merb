# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{merb_auth-more}
  s.version = "0.9.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Daniel Neighman"]
  s.date = %q{2008-10-03}
  s.description = %q{Additional resources for use with the merb_auth-core authentication framework.}
  s.email = %q{has.sox@gmail.com}
  s.extra_rdoc_files = ["README.textile", "LICENSE", "TODO"]
  s.files = ["LICENSE", "README.textile", "Rakefile", "TODO", "lib/merb_auth-more", "lib/merb_auth-more/merbtasks.rb", "lib/merb_auth-more/mixins", "lib/merb_auth-more/mixins/redirect_back.rb", "lib/merb_auth-more/mixins/salted_user", "lib/merb_auth-more/mixins/salted_user/ar_salted_user.rb", "lib/merb_auth-more/mixins/salted_user/dm_salted_user.rb", "lib/merb_auth-more/mixins/salted_user.rb", "lib/merb_auth-more/strategies", "lib/merb_auth-more/strategies/abstract_password.rb", "lib/merb_auth-more/strategies/basic", "lib/merb_auth-more/strategies/basic/basic_auth.rb", "lib/merb_auth-more/strategies/basic/openid.rb", "lib/merb_auth-more/strategies/basic/password_form.rb", "lib/merb_auth-more.rb", "spec/merb_auth-more_spec.rb", "spec/mixins", "spec/mixins/redirect_back_spec.rb", "spec/mixins/salted_user_spec.rb", "spec/spec_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://merbivore.com/}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{merb}
  s.rubygems_version = %q{1.3.0}
  s.summary = %q{Additional resources for use with the merb_auth-core authentication framework.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<merb_auth-core>, [">= 0.9.8"])
    else
      s.add_dependency(%q<merb_auth-core>, [">= 0.9.8"])
    end
  else
    s.add_dependency(%q<merb_auth-core>, [">= 0.9.8"])
  end
end
