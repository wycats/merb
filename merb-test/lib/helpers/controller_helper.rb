module Merb
  module Test
    module ControllerHelper
      #Not sure where ControllerExceptions moved to in 0.9.0+
      #include Merb::ControllerExceptions
      include RequestHelper
    end
  end
end
