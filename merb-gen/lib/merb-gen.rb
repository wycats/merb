require 'rubygems'
require 'templater'

%w(generator controller model resource).each do |file|
  require File.join(File.dirname(__FILE__), "merb-gen", file)
end