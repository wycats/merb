$TESTING=true
require "rubygems"
require "spec"
require "merb-core"
require File.join(File.dirname(__FILE__),"..",'lib',"merb-helpers")
require "date"

default_options = {:environment => 'test', :adapter => 'runner'}.merge({:merb_root => File.dirname(__FILE__) / 'fixture'})
options = default_options.merge($START_OPTIONS || {})
Merb.start_environment(options)

def unload_merb_helpers
  Merb.class_eval do
    remove_const("Helpers") if defined?(Merb::Helpers)
  end
end

def reload_merb_helpers
  unload_merb_helpers
  load(MERB_HELPERS_ROOT + "/lib/merb-helpers.rb") 
  Merb::Helpers.load
end

class FakeDMModel
  def self.properties
    [FakeColumn.new(:baz, TrueClass),
     FakeColumn.new(:bat, TrueClass)
    ]
  end
  
  def new_record?
    false
  end
  
  def errors
    FakeErrors.new(self)
  end
  
  def baz?
    true
  end
  alias baz baz?
  
  def bat?
    false
  end
  alias bat bat?
end


class FakeModel
  
  attr_accessor :vin, :make, :model
  
  def self.columns
    [FakeColumn.new(:foo, :string), 
     FakeColumn.new(:foobad, :string),
     FakeColumn.new(:desc, :string),
     FakeColumn.new(:bar, :integer), 
     FakeColumn.new(:barbad, :integer),      
     FakeColumn.new(:baz, :boolean),
     FakeColumn.new(:bazbad, :boolean),
     FakeColumn.new(:bat, :boolean),
     FakeColumn.new(:batbad, :boolean)
     ]     
  end
  
  def valid?
    false
  end
  
  def new_record?
    false
  end
  
  def errors
    FakeErrors.new(self)
  end
  
  def foo
    "foowee"
  end
  alias_method :foobad, :foo
  
  def bar
    7
  end
  alias_method :barbad, :bar
  
  def baz
    true
  end
  alias_method :bazbad, :baz
  
  def bat
    false
  end
  alias_method :batbad, :bat
  
  def nothing
    nil
  end
end

class FakeModel2 < FakeModel
  
  def id
    1
  end
  
  def foo
    "foowee2"
  end
  alias_method :foobad, :foo
  
  def bar
    "barbar"
  end
  
  def new_record?
    true
  end
  
end

class FakeModel3
  attr_accessor :foo, :bar
end


class FakeErrors
  
  def initialize(model)
    @model = model
  end
  
  def on(name)
    name.to_s.include?("bad")
  end
  
end

class FakeColumn
  attr_accessor :name, :type
  
  def initialize(name, type)
    @name, @type = name, type
  end
  
end




# -- Global custom matchers --

# A better +be_kind_of+ with more informative error messages.
#
# The default +be_kind_of+ just says
#
#   "expected to return true but got false"
#
# This one says
#
#   "expected File but got Tempfile"

module Merb
  module Test
    module RspecMatchers
      class IncludeLog
        def initialize(expected)
          @expected = expected
        end
        
        def matches?(target)
          target.log.rewind
          @text = target.log.read
          @text =~ (String === @expected ? /#{Regexp.escape @expected}/ : @expected)
        end
        
        def failure_message
          "expected to find `#{@expected}' in the log but got:\n" <<
          @text.map {|s| "  #{s}" }.join
        end
        
        def negative_failure_message
          "exected not to find `#{@expected}' in the log but got:\n" <<
          @text.map {|s| "  #{s}" }.join
        end
        
        def description
          "include #{@text} in the log"
        end
      end
      
      class BeKindOf
        def initialize(expected) # + args
          @expected = expected
        end

        def matches?(target)
          @target = target
          @target.kind_of?(@expected)
        end

        def failure_message
          "expected #{@expected} but got #{@target.class}"
        end

        def negative_failure_message
          "expected #{@expected} to not be #{@target.class}"
        end

        def description
          "be_kind_of #{@target}"
        end
      end

      def be_kind_of(expected) # + args
        BeKindOf.new(expected)
      end
      
      def include_log(expected)
        IncludeLog.new(expected)
      end
    end

    module Helper
      def running(&blk) blk; end

      def executing(&blk) blk; end

      def doing(&blk) blk; end

      def calling(&blk) blk; end
    end
  end
end

Spec::Runner.configure do |config|
  config.include Merb::Test::Helper
  config.include Merb::Test::RspecMatchers
  config.include Merb::Test::Rspec::ViewMatchers
  config.include Merb::Test::RequestHelper

  def with_level(level)
    Merb.logger = Merb::Logger.new(StringIO.new, level)
    yield
    Merb.logger
  end
end
