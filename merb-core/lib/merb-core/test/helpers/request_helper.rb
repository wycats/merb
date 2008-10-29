require "rack"

module Merb
  module Test
    module MakeRequest

      def request(uri, env = {})
        uri = url(uri) if uri.is_a?(Symbol)    

        if (env[:method] == "POST" || env["REQUEST_METHOD"] == "POST")
          params = env.delete(:body_params) if env.key?(:body_params)
          params = env.delete(:params) if env.key?(:params) && !env.key?(:input)

          unless env.key?(:input)
            env[:input] = Merb::Parse.params_to_query_string(params)
            env["CONTENT_TYPE"] = "application/x-www-form-urlencoded"
          end
        end

        if env[:params]
          uri << "?#{Merb::Parse.params_to_query_string(env.delete(:params))}"
        end

        if @__cookie__
          env["HTTP_COOKIE"] = @__cookie__
        end

        app = Merb::Rack::Application.new
        rack = app.call(::Rack::MockRequest.env_for(uri, env))

        rack = Struct.new(:status, :headers, :body, :url, :original_env).
          new(rack[0], rack[1], rack[2], uri, env)

        @__cookie__ = rack.headers["Set-Cookie"] && rack.headers["Set-Cookie"].join

        Merb::Dispatcher.work_queue.size.times do
          Merb::Dispatcher.work_queue.pop.call
        end

        rack
      end
    end    
    
    module RequestHelper
      include MakeRequest

      def describe_request(rack)
        "a #{rack.original_env[:method] || rack.original_env["REQUEST_METHOD"] || "GET"} to '#{rack.url}'"
      end

      def describe_input(input)
        if input.respond_to?(:controller_name)
          "#{input.controller_name}##{input.action_name}"
        elsif input.respond_to?(:original_env)
          describe_request(input)
        else
          input
        end
      end
      
      def status_code(input)
        input.respond_to?(:status) ? input.status : input
      end
      
      def requesting(*args)   request(*args) end
      def response_for(*args) request(*args) end
    end
  end
end