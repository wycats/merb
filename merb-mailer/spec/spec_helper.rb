$TESTING=true
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require "rubygems"
require "merb-core"
require "merb-mailer"
module Merb
  class MailController
    self._template_root = File.expand_path(File.join(File.dirname(__FILE__), "mailers/views"))
  end
end
Merb.start :environment => 'test'