module Merb::Test
  class RequestController < Merb::Controller
    
    def request_method
      "Method - #{request.method.to_s.upcase}"
    end
    
    def document
      '<html><body><div id="out"><div class="in">Hello</div></div></body></html>'
    end
    
    def counter
      value = (cookies[:counter] || 0).to_i + 1
      cookies[:counter] = value
      value
    end
    
    def delete
      cookies.delete(:counter)
      "Delete"
    end
    
    def domain
      value = (cookies[:counter] || 0).to_i + 1
      set_cookie :counter, value, :domain => "foo.example.org"
      value
    end
    
    def path
      value = (cookies[:counter] || 0).to_i + 1
      set_cookie :counter, value, :path => "/path/zomg"
      value
    end
    
    def expires
      value = (cookies[:counter] || 0).to_i + 1
      set_cookie :counter, value, :expires => Time.now
      value
    end
    
    def set
      set_cookie :cookie, request.path, :path => request.path
      "Setting"
    end
    
    def get
      cookies[:cookie]
    end
    
    def domain_set
      set_cookie :cookie, request.host, :domain => request.host
      "SET"
    end
    
    def domain_get
      cookies[:cookie]
    end
    
    # Don't actually set any cookies
    def void
      "Void"
    end
  end
end