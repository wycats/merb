require 'merb-assets/assets'
require 'merb-assets/assets_mixin'

Merb::Controller.send(:include, Merb::AssetsMixin)