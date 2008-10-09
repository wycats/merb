# setup all customizations that need to be set in order to get the framework running

# Slice Configuration
Merb::Slices::config[:"merb-auth-slice-password"][:no_default_strategies] = true

# Load the strategies
strategies = Merb::Plugins.config[:"merb-auth"][:strategies] || [:default_password_form, :default_basic_auth]
strategies.each do |s|
  Authentication.activate!(s)
end

# Setup customizations
Authentication.customize_default do
  #Mixin the user mixins
  require 'merb-auth-more/mixins/salted_user'
  Authentication.user_class.class_eval{ include Authentication::Mixins::SaltedUser }
  
  # Setup the session serialization
  Authentication.class_eval do
    
    def fetch_user(session_user_id)
      Authentication.user_class.get(session_user_id)
    end
    
    def store_user(user)
      user.nil? ? user : user.id
    end
    
  end # Authentication.class_eval
  
end