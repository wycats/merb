module Merb
  class Router
    class Behavior
      
      # Add all known slices to the router
      #
      # By combining this with Merb::Slices.register_and_activate and Merb::Slices.deactivate
      # one can enable/disable slices at runtime, without restarting your app.
      #
      # @param config<Hash> 
      #  Optional hash, mapping slice module names to their settings;
      #  set :path (or use a string) if you want to override what appears on the url.
      #
      # @yield A new Behavior instance is yielded in the block for nested routes.
      # @yieldparam ns<Behavior> The namespace behavior object.
      #
      # @example r.all_slices('BlogSlice' => 'blog', 'ForumSlice' => { :path => 'forum' })
      #
      # @note The block is yielded for each slice individually.
      def all_slices(config = {}, &block)
        Merb::Slices.slices.each { |module_name| add_slice(module_name, config[module_name] || {}, &block) }
      end
      
      # Add a Slice in a router namespace
      # 
      # @param slice_module<String, Symbol, Module> A Slice module to mount.
      # @param options<Hash, String> Optional hash, set :path if you want to override what appears on the url.
      # 
      # @yield A new Behavior instance is yielded in the block for nested routes.
      # @yieldparam ns<Behavior> The namespace behavior object.
      #
      # @return <Behaviour> The current router context.
      #
      # @note Normally you should specify the slice_module using a String or Symbol
      #       this ensures that your module can be removed from the router at runtime.
      def add_slice(slice_module, options = {}, &block)
        if Merb::Slices.exists?(slice_module)
          options = { :path => options } if options.is_a?(String)
          slice_module = Object.full_const_get(slice_module.to_s) if slice_module.class.in?(String, Symbol)
          namespace = options[:namespace] || slice_module.to_s.snake_case
          options[:path] ||= options[:namespace] || slice_module.identifier
          options[:default_routes] = true unless options.key?(:default_routes)
          Merb.logger.info!("mounting slice #{slice_module} at /#{options[:path]}")
          self.namespace(namespace.to_sym, options.except(:default_routes)) do |ns|
            slice_module.setup_router(ns)
            ns.match(%r{/:controller(/:action(/:id)?)?(\.:format)?}).to(options[:params] || {}) if options[:default_routes]
            block.call(ns) if block.respond_to?(:call)
          end
        else 
          Merb.logger.info!("skipped adding slice #{slice_module} to router...")
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