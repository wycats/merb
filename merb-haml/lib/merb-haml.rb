# make sure we're running inside Merb
if defined?(Merb)  
  require "haml"
  require "merb-haml/template"
  Merb::Plugins.add_rakefiles(File.join(File.dirname(__FILE__) / "merb-haml" / "merbtasks"))
  
  Merb::Plugins.config[:sass] ||= {}

  Merb::BootLoader.after_app_loads do
    
    template_locations = []
    template_locations << Merb.dir_for(:stylesheet) / "sass"
    
    # extract template locations list from sass config
    config_location = Merb::Plugins.config[:sass][:template_location]
    if config_location.is_a? Hash
      template_locations += config_location.keys
    elsif config_location
      template_locations << config_location.to_s
    end
    
    # setup sass if any template paths match
    if template_locations.any?{|location| File.directory?(location) }
      require "sass"
      if Merb::Config[:sass]
        Merb.logger.info("Please define your sass settings in Merb::Plugins.config[:sass] not Merb::Config")
        Sass::Plugin.options = Merb::Config[:sass]
      else
        Sass::Plugin.options = Merb::Plugins.config[:sass]
      end
    end
    
  end
  
  generators = File.join(File.dirname(__FILE__), 'generators')
  Merb.add_generators generators / "resource_controller"
  Merb.add_generators generators / "controller"
  Merb.add_generators generators / "layout"
end
