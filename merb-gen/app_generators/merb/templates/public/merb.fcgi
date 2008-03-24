#!/usr/bin/env ruby
                                                               
require 'rubygems'
require 'merb-core'
                   
# If the fcgi process runs as apache, make sure
# we have an inlinedir set
unless ENV["INLINEDIR"] || ENV["HOME"]
  tmpdir = File.dirname(__FILE__) + "/../tmp"
  unless File.directory?(tmpdir)
    Dir.mkdir(tmpdir)
  end                
  
  ENV["INLINEDIR"] = tmpdir
  
end
                              
# the merb root should alwasy be located below
# to set the root dir
argv = ARGV + %w[-a fcgi -m ..]               
                     
# start
Merb.start(argv)