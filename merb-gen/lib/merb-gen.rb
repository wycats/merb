require 'rubygems'
require 'templater'

%w(generator model).each do |file|
  require File.join(File.dirname(__FILE__), "merb-gen", file)
end