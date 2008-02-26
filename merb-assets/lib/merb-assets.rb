require 'merb-assets/assets'
require 'merb-assets/assets_mixin'

Merb::BootLoader.before_app_loads do
  Merb::Controller.send(:include, Merb::AssetsMixin)
end