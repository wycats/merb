module Merb::Test::Fixtures::Controllers
  class Url < Testing
    
    def void
      'index'
    end
    
    def this_route
      url(:this)
    end
    
    def this_route_with_page
      url(:this, :page => 2)
    end
    
    def one_optionals
      url(:this, :one => params[:one])
    end
    
    def two_optionals
      url(:this, :one => params[:one], :two => params[:two])
    end
    
    # --- Resource routes ---
    
    def index
      url(:this)
    end
    
    def show
      url(:this)
    end
    
    def new
      url(:this)
    end
    
    def edit
      url(:this)
    end
  end
end