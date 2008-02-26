require 'rubygems'
require "merb-core"

Merb.start :environment => 'test'

require File.join( File.dirname(__FILE__), "..", "lib", "merb-test" )