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
  module Drivers
    class AbstractDriver
      attr :model
  
      def initialize(obj)
        @model = obj
      end
  
      def new_record?
        if !@model.respond_to?(:new_record?)
          raise AbstractDriverMethod, "#{@model.class} doesn't define a way to check if a new record is new or not!"
        else
          @model.new_record?
        end
      end
  
      def errors
        if !@model.respond_to?(:errors)
          raise AbstractDriverMethod, "#{@model.class} doesn't define a way to look up errors!"
        else
          @model.errors
        end
      end
  
      def valid?
        if !@model.respond_to?(:valid?)
          raise AbstractDriverMethod, "#{@model.class} doesn't define a way to check if an instance is valid!"
        else
          @model.valid?
        end
      end
    end
  end
end