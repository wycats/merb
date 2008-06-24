require 'rubygems'
require 'templater'
require 'sha1'

path = File.join(File.dirname(__FILE__), "merb-gen")

require path / "generator"
require path / "merb"
require path / "merb_flat"
require path / "merb_very_flat"
require path / "controller"
require path / "part_controller"
require path / "model"
require path / "resource_controller"
require path / "resource"