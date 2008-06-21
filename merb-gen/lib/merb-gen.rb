require 'rubygems'
require 'templater'

%w(generator merb controller model resource_controller resource).each do |file|
  require File.join(File.dirname(__FILE__), "merb-gen", file)
end