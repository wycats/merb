require 'rubygems'
require "merb-core"
require File.join( File.dirname(__FILE__), "..", "lib", "merb-test" )

Merb.start :environment => "test", :adapter => "runner"