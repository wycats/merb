require 'merb-assets/assets'
require 'merb-assets/assets_mixin'

Merb::BootLoader.before_app_loads do
  Merb::Controller.send(:include, Merb::AssetsMixin)
end


Merb::Plugins.config[:asset_helpers] = {
    :max_hosts => 4,
    :asset_domain => "assets%s",
    :domain => "my-awesome-domain.com",
    :use_ssl => false,
    
    # Global prefix/suffix for css/js include tags, overridable in js_include_tag and css_include_tag
    #
    # :js_prefix => "http://cdn.example.com"
    # require_js :application # => "http://cdn.example.com/javascripts/application.js"
    #
    # :js_suffix => "_#{MyApp.version}"
    # require_js :application # => "/javascripts/application_0.2.2.js"
    :js_prefix => nil,
    :js_suffix => nil,
    :css_prefix => nil,
    :css_suffix => nil
  } if Merb::Plugins.config[:asset_helpers].nil?