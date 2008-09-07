require 'rubygems'
require 'merb-core'
require 'sha1'
gem 'templater', '>= 0.2.0'
require 'templater'

path = File.join(File.dirname(__FILE__))

require path / "merb-gen"   / "generator"
require path / "merb-gen"   / "named_generator"
require path / "merb-gen"   / "namespaced_generator"
require path / "generators" / "merb"
require path / "generators" / "merb" / "merb_full"
require path / "generators" / "merb" / "merb_flat"
require path / "generators" / "merb" / "merb_very_flat"
require path / "generators" / "merb_plugin"
require path / "generators" / "controller"
require path / "generators" / "helper"
require path / "generators" / "part_controller"
require path / "generators" / "migration"
require path / "generators" / "session_migration"
require path / "generators" / "model"
require path / "generators" / "resource_controller"
require path / "generators" / "resource"
require path / "generators" / "layout"
require path / "generators" / "scripts"

Templater::Discovery.discover!("merb-gen")

# Require all generators that plugins have added to merb, after the app has loaded.
Merb::BootLoader.after_app_loads do
  Merb.generators.each do |file|
    require file
  end
end