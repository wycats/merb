require 'rubygems'
require 'merb-core'
require 'sha1'
gem 'templater', '>= 0.1.2'
require 'templater'

path = File.join(File.dirname(__FILE__), "merb-gen")

require path / "generator"
require path / "merb"
require path / "merb" / "merb_full"
require path / "merb" / "merb_flat"
require path / "merb" / "merb_very_flat"
require path / "merb_plugin"
require path / "controller"
require path / "helper"
require path / "part_controller"
require path / "migration"
require path / "session_migration"
require path / "model"
require path / "resource_controller"
require path / "resource"
require path / "freezer"

Templater::Discovery.discover!("merb-gen")

# Require all generators that plugins have added to merb, after the app has loaded.
Merb::BootLoader.after_app_loads do
  Merb.generators.each do |file|
    require file
  end
end