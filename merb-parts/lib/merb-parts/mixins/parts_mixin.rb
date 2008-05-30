module Merb
  module PartsMixin
    
    # Dispatches a PartController.
    # ==== Parameters
    # opts<Hash>:: A Hash of Options. (see below)
    #
    # ==== Options
    # An option hash has two parts.
    # 1. keys that are Merb::PartControllers with values that are action names (as symbols)
    # 2. key value pairs that will become available in the PartController as params merged
    #    with the web controllers params
    #
    # ==== Example
    #  Calling a part controller
    #  {{{
    #    part TodoPart => :list
    #   }}}
    #
    #  Calling a part with additional options
    #  {{{
    #    part TodoPart => :list, :limit => 20, :user => current_user 
    #  }}}
    #
    # ==== Returns
    #   Returns the result of the PartControllers action, which is a string.
    def part(opts = {})
      # Extract any params out that may have been specified
      klasses, opts = opts.partition do |k,v| 
        k.respond_to?(:ancestors) && k.ancestors.include?(Merb::PartController)
      end       
        
      opts = Hash[*(opts.flatten)]
      
      res = klasses.inject([]) do |memo,(klass,action)|
        memo << klass.new(self, opts)._dispatch(action)
      end
      res.size == 1 ? res[0] : res
    end
    
  end
end