# This file is specifically setup for use with the merb-auth plugin.
# This file should be used to setup and configure your authentication stack.
# It is not required and may safely be deleted.
#
# When using merb-auth there are a number of options you may use.
#
# Merb::Plugins.config[:"merb-auth"][:no_strategies] = true 
# Merb::Plugins.config[:"merb-auth"][:strategies] = [:default_openid, :default_password_form]
#
# The above statements  will either set merb-auth (no merb-auth-core or merb-auth-more) to not load any strategies
# The next statement sets the strategies to load by default. 
#
#
# Merb::Plugins.config[:"merb-auth"][:no_salted_user] = true
# 
# The above statement will cause the salted_user mixin _not_ to be mixed in automatically.  
# Please see the mixin documentation for requirements to use it
#
# To change the parameter names for the password or login field you may set either of these two options
#
# Merb::Plugins.config[:"merb-auth"][:login_param]    = :email 
# Merb::Plugins.config[:"merb-auth"][:password_param] = :my_password_field_name
