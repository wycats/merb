# Includes files into the class to allow it to minimally delegates to a web controller
module Merb
  module Mixins
    module WebController
      
      def self.included(base)
        [:content_type, :web_controller].each do |attr|
          base.send(:attr_accessor, attr)
        end
        base.send(:include, InstanceMethods)
        base.send(:extend, ClassMethods)
      end
      
      module InstanceMethods
        def request
           @web_controller.request  
        end

        def cookies
          @web_controller.cookies
        end  

        def headers
          @web_controller.headers
        end

        def session
          @web_controller.session
        end

        def response
          @web_controller.response
        end    

        def route
          request.route
        end

        def url(name, rparams={})
          Merb::Router.generate(name, rparams,
            { :controller => @web_controller.controller_name,
              :action => @web_controller.action_name,
              :format => params[:format]
            }
          )
        end
        
        private 
        # This method is here to overwrite the one in the general_controller mixin
        # The method ensures that when a url is generated with a hash, it contains a controller
        def get_controller_for_url_generation(opts)
           controller = opts[:controller] || @web_controller.params[:controller]
           raise "No Controller Specified for url()" unless controller
           controller
        end
        
      end
      
      module ClassMethods
        
      end
      
      
      
    end # WebController
  end # Mixins
end # Merb