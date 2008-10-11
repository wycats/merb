class Merb::Router::Behavior
  
  def protect(*strategies, &block)
    p = Proc.new do |request, params|
      if request.session.authenticated?
        params
      else
        if strategies.blank?
          result = request.session.authenticate!(request, params)
        else
          result = request.session.authenticate!(request, params, *strategies)
        end
      
        if request.session.authentication.halted?
          auth = request.session.authentication
          [auth.status, auth.headers, auth.body]
        else
          params
        end
      end
    end
    defer(p, &block)
  end
  
end