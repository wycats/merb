module Merb
  class Router
    class Behavior
      
      # This method should activate the slices in merb-auth in the router
      # Provide the options that you would normally provide to the slice method
      # when adding slices
      def merb_auth_routes(opts = {})
        slice(:merb_auth_slice_password, opts)
      end
      
    end # Behavior
  end # Router
end # Merb