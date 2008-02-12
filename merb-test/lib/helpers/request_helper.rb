# DOC: Yehuda Katz FAILED
module Merb
  module Test
    module RequestHelper
      # ==== Parameters
      # env<Hash>:: A hash of environment keys to be merged into the default list
      # opt<Hash>:: A hash of options (see below)
      #
      # ==== Options (choose one)
      # :post_body<String>:: The post body for the request
      # :body<String>:: The body for the request
      # 
      # ==== Returns
      # FakeRequest:: A Request object that is built based on the parameters
      #
      # ==== Note
      # If you pass a post_body, the content-type will be set as URL-encoded
      #
      #---
      # @public
      
      def fake_request(env = {}, opt = {})
        if opt[:post_body]
          req = opt[:post_body]
          env.merge!(:content_type => "application/x-www-form-urlencoded")
        else
          req = opt[:req]
        end
        Merb::Test::FakeRequest.new(env, req ? StringIO.new(req) : nil)
      end
      
      # DOC: Yehuda Katz FAILED
      def dispatch_to(controller_klass, action, params = {}, env = {}, &blk)
        request = fake_request(env.merge(:query_string => Merb::Responder.params_to_query_string(params)))
        
        dispatch_request(request, controller_klass, action, &blk)
      end
      
      def dispatch_multipart_to(controller_klass, action, params = {}, env = {}, &blk)
        m = Merb::Test::Multipart::Post.new(params)
        body, head = m.to_multipart
        request = fake_request(env.merge(:content_type => head, :content_length => body.length), :post_body => body)
        
        dispatch_request(request, controller_klass, action, &blk)
      end
      
      def dispatch_request(request, controller_klass, action, &blk)
        controller = controller_klass.new(request)
        controller.instance_eval(&blk) if block_given?
        controller._dispatch(action)
        
        Merb.logger.info controller._benchmarks.inspect
        Merb.logger.flush
        
        controller
      end
      
      def get(controller_klass, action, params = {}, env = {}, &blk)
        dispatch_to(controller_klass, action, params, env.merge(:request_method => 'GET'))
      end
      
      def post(controller_klass, action, params = {}, env = {}, &blk)
        dispatch_to(controller_klass, action, params, env.merge(:request_method => 'POST'))
      end
      
      def put(controller_klass, action, params = {}, env = {}, &blk)
        dispatch_to(controller_klass, action, params, env.merge(:request_method => 'PUT'))
      end
      
      def delete(controller_klass, action, params = {}, env = {}, &blk)
        dispatch_to(controller_klass, action, params, env.merge(:request_method => 'DELETE'))
      end
      
      def head(controller_klass, action, params = {}, env = {}, &blk)
        dispatch_to(controller_klass, action, params, env.merge(:request_method => 'HEAD'))
      end
      
      def multipart_post(controller_klass, action, params, env = {}, &blk)
        dispatch_multipart_to(controller_klass, action, params, env.merge(:request_method => 'POST'))
      end
      
      def multipart_put(controller_klass, action, params, env = {}, &blk)
        dispatch_multipart_to(controller_klass, action, params, env.merge(:request_method => 'PUT'))
      end
    end
  end
end