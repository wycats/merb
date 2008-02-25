module Merb
  module Test
    module RouteHelper
      include RequestHelper
      
      def url(name, params={})
        Merb::Router.generate(name, params)
      end
      
      def request_to(path, method = :get, env = {})
        env[:request_method] ||= method.to_s.upcase
        env[:request_uri] = path
        
        check_request_for_route(fake_request(env))
      end
    end
  end
end