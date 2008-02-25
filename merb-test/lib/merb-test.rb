require 'hpricot'

require 'merb-core/test/fake_request'
require 'merb-core/test/request_helper'
require 'merb-core/test/multipart_helper'

require File.join(File.dirname(__FILE__), "test_ext", "hpricot")
require File.join(File.dirname(__FILE__), "test_ext", "object")
                  
require File.join(File.dirname(__FILE__), "helpers", "hpricot_helper")
require File.join(File.dirname(__FILE__), "helpers", "controller_helper")

module Merb; module Test; module Helpers
  include Merb::Test::ControllerHelper
  include Merb::Test::HpricotHelper
end; end; end