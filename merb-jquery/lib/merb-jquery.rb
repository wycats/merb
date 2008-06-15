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

# make sure we're running inside Merb
if defined?(Merb::Plugins)

  # Merb gives you a Merb::Plugins.config hash...feel free to put your stuff in your piece of it
  #Merb::Plugins.config[:merb_jquery] = {
  #  :merb_best_framework_ever => true
  #}

  Merb::BootLoader.before_app_loads do
    # require code that must be loaded before the application
    Merb::Controller.send(:include, Merb::JqueryMixin)
  end

  Merb::BootLoader.after_app_loads do
    # code that can be required after the application loads
  end

  Merb::Plugins.add_rakefiles "merb-jquery/merbtasks"
end