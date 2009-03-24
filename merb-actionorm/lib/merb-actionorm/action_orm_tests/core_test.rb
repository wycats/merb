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
require 'helper'
require File.join(File.dirname(__FILE__), '..', 'action_orm', 'core')

module TestModule
end

class TestModuleModel
  include TestModule
  
  def initialize
    @new = true
    @valid = true
  end
  def save
    @new = false
  end
  def new_record?
    @new
  end
  def invalidate
    @valid = false
  end
  def valid?
    @valid
  end
end

class TestFailingModel
end

class TestSubclassModel < ActionORM::TestORMModel
end

class CoreTest < Test::Unit::TestCase
  def setup
    @model = ActionORM::TestORMModel.new
    @modulemodel = TestModuleModel.new
  end

  def teardown
  end

  def test_supports?
    assert ActionORM.supports?(@model)
  end
  
  def test_supports_for_module
    ActionORM.use :driver => ActionORM::Drivers::TestORMDriver, :for => TestModuleModel
    assert ActionORM.supports?(@modulemodel)
  end
  
  def test_supports_failing?
    assert !ActionORM.supports?(TestFailingModel.new)
  end
  
  def test_driver
    assert_equal @model, (ActionORM.for @model).model
  end
  
  def test_subclass_driver
    assert ActionORM.supports?(TestSubclassModel.new)
  end
end