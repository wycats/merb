module MerbExceptions
  module ControllerExtensions
    
    def self.included(mod)
      mod.class_eval do
        def base
          self.render_and_notify template_or_message, :layout=>false
        end
        
        def exception
          self.render_and_notify template_or_message, :layout=>false
        end
        
        private
        
        def template_or_message
          if File.exists?(Merb.root / 'app' / 'views' / 'exceptions' / 'internal_server_error.html.erb')
            :internal_server_error
          else
            '500 exception. Please customize this page by creating app/views/exceptions/internal_server_error.html.erb.'
          end
        end
      end
    end
    
    def render_and_notify(*opts)
      self.render_then_call(render(*opts)) { notify_of_exceptions }
    end

    def notify_of_exceptions
      request = self.request

      details = {}
      details['exceptions']      = request.exceptions
      details['params']          = params
      details['environment']     = request.env.merge( 'process' => $$ )
      details['url']             = "#{request.protocol}#{request.env["HTTP_HOST"]}#{request.uri}"
      MerbExceptions::Notification.new(details).deliver!
    end
  end
end