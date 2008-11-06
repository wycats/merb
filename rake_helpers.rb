require 'rubygems'
require 'rake/gempackagetask'
require 'rubygems/specification'
require 'date'
require "spec/rake/spectask"
require File.join(File.dirname(__FILE__), "merb-core/lib/merb-core/version")
require File.join(File.dirname(__FILE__), "merb-core/lib/merb-core/tasks/merb_rake_helper")
require 'rake/testtask'

require "extlib/tasks/release"