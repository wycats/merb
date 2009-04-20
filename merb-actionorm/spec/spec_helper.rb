$:.push File.join(File.dirname(__FILE__), '..', 'lib')
require 'merb-actionorm'
action_orm_path = File.join(File.dirname(__FILE__), '..', 'lib', 'merb-actionorm', 'action_orm')
require File.join(action_orm_path, 'test_orm_model')
require File.join(action_orm_path, 'drivers','test_orm_driver')
require 'rubygems'

begin
  gem 'sequel'
rescue LoadError => load_error
  puts "To run the specs properly, you need to have sequel installed #{load_error}"
else
  require 'sequel'
end

begin
  gem 'dm-core'
  gem 'dm-validations'
rescue LoadError => load_error
  puts "To run the specs properly, you need to have DataMapper installed #{load_error}"
else
  require 'dm-core'
  require 'dm-validations'
end

begin
  gem 'activerecord'
rescue LoadError => load_error
  puts "To run the specs properly, you need to have active_record installed #{load_error}"
else
  require 'activerecord'
end