module Merb
  module Slices
    
    class Controller < Merb::Controller
  
      # Reference this controller's slice module
      class_inheritable_reader :slice
  
      class << self
    
        # Setup controller paths when inheriting
        #
        # @param klass<Merb::Slices::Controller>
        #   The new controller inheriting from the base class (in a module).
        def inherited(klass)
          super # important to call this first         
          module_name = klass.to_s.split('::').first
          mod = Object.full_const_get(module_name) rescue nil
          if (slice_path = Merb::Slices.paths[module_name]) && mod
            klass.write_inheritable_attribute(:slice, mod)
            klass._template_root  = mod.dir_for(:view)
            klass._template_roots = []
            # app-level app/views directory for shared and fallback views, layouts and partials
            klass._template_roots << [Merb.dir_for(:view), :_template_location] if Merb.dir_for(:view)
            # slice-level app/views for the standard supplied views
            klass._template_roots << [self._template_root, :_slice_template_location] 
            # app-level slices/<slice>/app/views for specific overrides
            klass._template_roots << [mod.app_dir_for(:view), :_slice_template_location]
          end
        end
    
      end
  
      private
      
      # Reference this controller's slice module directly
      def slice; self.class.slice; end
  
      # This is called after the controller is instantiated to figure out where to
      # for templates under the _template_root. This helps the controllers
      # of a slice to locate templates without looking in a subdirectory with
      # the name of the module. Instead it will just be app/views/controller/*
      #
      # @param context<#to_str> The controller context (the action or template name).
      # @param type<#to_str> The content type. Defaults to nil.
      # @param controller<#to_str> The name of the controller. Defaults to controller_name.
      #
      # @return <String> 
      #   Indicating where to look for the template for the current controller,
      #   context, and content-type.
      def _slice_template_location(context, type = nil, controller = controller_name)
        if controller && controller.include?('/')
          # skip first segment if given (which is the module name)
          segments = controller.split('/')
          "#{segments[1,segments.length-1]}/#{context}.#{type}"
        else
          # default template location logic
          _template_location(context, type, controller)
        end
      end

    end
    
  end
end