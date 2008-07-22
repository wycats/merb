require 'rubygems'
require 'merb-core'
require 'templater'
require 'sha1'

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

# Require all generators that plugins have added to merb, after the app has loaded.
Merb::BootLoader.after_app_loads do
  # TODO: remove this if statement once generator hooks are added to merb-core proper
  if Merb.respond_to?(:generators)
    Merb.generators.each do |file|
      require file
    end
  end
end