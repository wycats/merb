begin
  require 'rubygems/dependency'

  module Gem
    class Dependency
      # :api: private
      attr_accessor :require_block, :require_as, :original_caller, :source
    end
  end
rescue LoadError
  Merb.warn! "Merb requires Rubygems 1.1 and later. " \
    "Please upgrade RubyGems with gem update --system."  
end