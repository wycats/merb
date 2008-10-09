class Authentication
  module Strategies
    # To use the password strategies, it is expected that you will provide
    # an @authenticate@ method on your user class.  This should take two parameters
    # login, and password.  It should return nil or the user object.
    module Basic
      
      class Base < Authentication::Strategy
        abstract!
        
        # Overwrite this method to customize the field
        def self.password_param
          :password
        end
        
        # Overwrite this method to customize the field
        def self.login_param
          :login
        end
        
        def password_param
          Base.password_param
        end
        
        def login_param
          Base.login_param
        end
      end # Base      
    end # Password
  end # Strategies
end # Authentication