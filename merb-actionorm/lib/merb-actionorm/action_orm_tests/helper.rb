#--
# Copyright (c) 2004-2008 David Heinemeier Hansson
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++
require 'rubygems'
require 'test/unit'

action_orm_path = File.join(File.dirname(__FILE__), '..', 'action_orm')

require File.join(action_orm_path, '..', 'action_orm')
require File.join(action_orm_path, 'test_orm_model')
require File.join(action_orm_path, 'drivers','test_orm_driver')

def uses_mocha(description)
  gem 'mocha', '>= 0.9.3'
  require 'mocha'
  yield
rescue LoadError
  $stderr.puts "Skipping #{description} tests. `gem install mocha` and try again."
end

def uses_active_record(description)
    gem 'active_record'
    require 'active_record'
    yield
  rescue LoadError
    $stderr.puts "Skipping #{description} tests. `gem install active_record` and try again."
end

def uses_datamapper(description)
    gem 'dm-core'
    gem 'dm-validations'
    require 'dm-core'
    require 'dm-validations'
    yield
  rescue LoadError
    $stderr.puts "Skipping #{description} tests. `gem install dm-core dm-validations` and try again."
end

ActionORM.use :orm => :test_orm