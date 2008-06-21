require 'rubygems'
require 'templater'

path = File.join(File.dirname(__FILE__), "merb-gen")

require path / "generator"
require path / "merb"
require path / "merb_flat"
require path / "merb_very_flat"
require path / "controller"
require path / "model"
require path / "resource_controller"
require path / "resource"