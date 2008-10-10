# This is a default user class used to activate merb-auth.  Feel free to change from a User to 
# Some other class, or to remove it altogether.  If removed, merb-auth may not work by default.
# 
# You will need to setup your database and migrate your data.
class User
  include DataMapper::Resource
  
  # Sets this class to be the default used in merb-auth strategies
  Merb::Authentication.user_class = self 
  
  property :id,     Serial
  property :login,  String
  
end