class Authentication
  module Mixins
    module SaltedUser
      module ARClassMethods
        
        def self.extended(base)
          base.class_eval do
            
            validates_presence_of     :password,                   :if => :password_required?
            validates_presence_of     :password_confirmation,      :if => :password_required?
            validates_confirmation_of :password,                   :if => :password_required?
            
            before_save :encrypt_password
          end # base.class_eval
          
          # Setup the session serialization
          Authentication.class_eval <<-Ruby

            def fetch_user(session_user_id)
              #{base.name}.find(session_user_id)
            end

            def store_user(user)
              user.nil? ? user : user.id
            end

          Ruby
                  
        end # self.extended
        
        def authenticate(login, password)
          @u = find(:first, :conditions => ["#{Authentication::Strategies::Basic::Base.login_param} = ?", login])
          @u && @u.authenticated?(password) ? @u : nil
        end
      end # ARClassMethods
    end # SaltedUser
  end # Mixins
end # Authentication 