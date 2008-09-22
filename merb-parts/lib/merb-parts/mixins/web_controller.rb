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

        def url(name, *args)
          @web_controller.url(name, *args)
        end
        
      end
      
      module ClassMethods
        
      end
      
      
      
    end # WebController
  end # Mixins
end # Merb