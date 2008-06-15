module Merb
  module JqueryMixin
    def jquery(string=nil, &blk)
      if string 
        throw_content(:for_jquery, string)
      elsif block_given?
        throw_content(:for_jquery, &blk)
      else
        catch_content :for_jquery
      end
    end
  end
end

Merb::BootLoader.before_app_loads do
  Merb::Controller.send(:include, Merb::JqueryMixin)
end