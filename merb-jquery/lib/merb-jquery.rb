module Merb
  module JqueryMixin
    def jquery(string=nil, &blk)
      if string || block_given?
        throw_content(:for_jquery, (string || &blk))
      else
        catch_content :for_jquery
      end
    end
  end
end

Merb::BootLoader.before_app_loads do
  Merb::Controller.send(:include, Merb::JqueryMixin)
end