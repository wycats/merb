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

    # if you need to handle the render yourself for some reason, you can call
    # this method directly. It sends notifications without any rendering logic.
    # Note though that if you are sending lots of notifications this could
    # delay sending a response back to the user so try to avoid using it
    # where possible.
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