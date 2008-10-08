Gem::Specification.new do |s|
  s.name = %q{merb_exceptions}
  s.version = "0.9.7"

  s.specification_version = 2 if s.respond_to? :specification_version=

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Andy Kent"]
  s.date = %q{2008-05-12}
  s.description = %q{Allows Merb to forward exceptions to emails or web hooks}
  s.email = ["andy@new-bamboo.co.uk"]
  s.extra_rdoc_files = ["LICENSE"]
  s.files = ["LICENSE", "README.markdown", "Rakefile", "lib/merb_exceptions.rb", "lib/merb_exceptions/controller_extensions.rb", "lib/merb_exceptions/notification.rb", "lib/merb_exceptions/templates/email.erb", "spec/spec_helper.rb", "spec/unit/notification_spec.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/wycats/merb-plugins/}
  s.rdoc_options = ["--main", "README.markdown"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.1.0}
  s.summary = %q{Allows Merb to forward exceptions to emails or web hooks}
  s.test_files = ["spec/unit/notification_spec.rb"]
end
