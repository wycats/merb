module Merb
  module Rack
    class Profiler < Merb::Rack::Middleware

      # :api: private
      def initialize(app, min=1, iter=1)
        super(app)
        @min, @iter = min, iter
      end

      # :api: plugin
      def call(env)
        __profile__("profile_output", @min, @iter) do
          @app.call(env)
        end
      end

      
    end
  end
end
