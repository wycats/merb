$TESTING=true
$:.push File.join(File.dirname(__FILE__), '..', 'lib')

require 'rubygems'
require 'merb-gen'
require 'generators/base'
require 'generators/full'
require 'generators/thin'
require 'generators/very_thin'