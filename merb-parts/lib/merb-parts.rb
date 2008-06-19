require File.join(File.dirname(__FILE__), "merb-parts", "part_controller")
require File.join(File.dirname(__FILE__), "merb-parts", "mixins", "parts_mixin")

Merb::Controller.send(:include, Merb::PartsMixin)