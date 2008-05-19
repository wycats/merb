module Merb
  class Router
    class Behavior
      
      # Add a Slice in a router namespace
      # 
      # ==== Parameters
      # slice_module<Module, String, Symbol>:: A Slice module to mount
      # options<Hash>:: Optional hash, set :path if you want to override what appears on the url
      # &block:: A new Behavior instance is yielded in the block for nested resources.
      #
      # ==== Block parameters
      # r<Behavior>:: The namespace behavior object.
      #
      # ==== Returns
      # Behaviour:: The current router context.
      def add_slice(slice_module, options = {}, &block)
        options = { :path => options } if options.is_a?(String)
        slice_module = Object.full_const_get(slice_module.to_s) if slice_module.class.in?(String, Symbol)
        namespace = options[:namespace] || slice_module.to_s.snake_case
        options[:path] ||= namespace.gsub('_', '-')
        options[:default_routes] = true unless options.key?(:default_routes)
        self.namespace(namespace.to_sym, options.except(:default_routes)) do |ns|
          slice_module.setup_router(ns)
          ns.match(%r{/:controller(/:action(/:id)?)?(\.:format)?}).to(options[:params] || {}) if options[:default_routes]
          block.call(ns) if block.respond_to?(:call)
        end
        self
      end
      
      # Insert a slice directly into the current router context.
      #
      # This will still setup a namespace, but doesn't set a path prefix. 
      def slice(slice_module, options = {}, &block)
        add_slice(slice_module, options.merge(:path => ''), &block)
      end
      
    end
  end
end