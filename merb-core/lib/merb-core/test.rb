require 'merb-core/test/test_ext/object'
require 'merb-core/test/test_ext/string'

module Merb; module Test; end; end

require 'merb-core/test/helpers'

begin
  require 'webrat'
  require 'webrat/merb'
rescue LoadError => e
  Merb.fatal! "Couldn't load Webrat. You should run: sudo gem install webrat", e
end

if Merb.test_framework.to_s == "rspec"
  require 'merb-core/test/test_ext/rspec'
  require 'merb-core/test/matchers'
end
