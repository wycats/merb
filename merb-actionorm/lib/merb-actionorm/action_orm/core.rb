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
module ActionORM
  class ActionORMError < StandardError; end
  class DriverNotFoundException < ActionORMError; end
  class AbstractDriverMethod < ActionORMError; end
  class UnknownORM < ActionORMError; end

  module Core
    module ClassMethods

      def for(obj)
        return nil if obj.nil?
        unless supports?(obj)
          ActionORM.use :driver => ActionORM::Drivers::AbstractDriver, :for => obj.class
        end
        driver = driver_registry[find_key(obj)]
        case driver
        when :compliant
          obj
        when NilClass
          obj
        else
          driver.new(obj)
        end
      end

      def use(options)
        case options[:orm].to_s
        when /test[_\W\s]?orm/i
          options = {:for => TestORMModel, :driver => Drivers::TestORMDriver}.merge(options)
        when /sequel/i
          options = {:for => Sequel::Model, :driver => Drivers::SequelDriver}.merge(options)
        end
        ActionORM.register(options[:for], options[:driver])
      end
      
      def find_key(obj)
        return nil if obj.nil?
        unless driver_key_cache.key?(obj.class)
          driver_key_cache[obj.class] = driver_registry.keys.find {|k, v| obj.is_a? k }
        end
        driver_key_cache[obj.class]
      end
      
      protected
      
        def supports?(obj)
          !find_key(obj).nil?
        end
      
        def driver_registry
          @_driver_registry ||= {}
        end
        
        def driver_key_cache
          @_driver_key_cache ||= {}
        end
      
        def register(obj_class, obj_driver_class)
          driver_registry[obj_class] = obj_driver_class
        end
        
    end
  end
end