# setup all customizations that need to be set in order to get the framework running

# Slice Configuration
Merb::Slices::config[:"merb-auth-slice-password"][:no_default_strategies] = true

# Load the strategies
unless Merb::Plugins.config[:"merb-auth"][:no_strategies] # Set this option to true to declare your own stratgies
  strategies = Merb::Plugins.config[:"merb-auth"][:strategies] || [:default_password_form, :default_basic_auth]
  strategies.each do |s|
    Merb::Authentication.activate!(s)
  end
end

# Setup customizations.  Overwrite Merb::Authentication.user_class in 
# lib/authentication/setup.rb
Merb::Authentication.customize_default do
  #Mixin the user mixins
  unless Merb::Plugins.config[:"merb-auth"][:no_salted_user] # Use this to prevent mixing in the salted user mixin
    require 'merb-auth-more/mixins/salted_user'
    Merb::Authentication.user_class.class_eval{ include Merb::Authentication::Mixins::SaltedUser }
  end  
end
