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
          (Merb::Plugins[:"merb-auth"][:password_field] || :password).to_s.to_sym
        end
        
        # Overwrite this method to customize the field
        def self.login_param
          (Merb::Plugins[:"merb-auth"][:login_field] || :login).to_s.to_sym
        end
        
        def password_param
          @password_param ||= Base.password_param
        end
        
        def login_param
          @login_param ||= Base.login_param
        end
      end # Base      
    end # Password
  end # Strategies
end # Authentication