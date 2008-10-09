class Authentication
  include Extlib::Hook
  attr_accessor :session
  attr_writer   :error_message
  
  class DuplicateStrategy < Exception; end
  class MissingStrategy < Exception; end
  class NotImplemented < Exception; end
  
  # This method returns the default user class to use throughout the
  # merb-auth authentication framework.  Authentication.user_class can
  # be used by other plugins, and by default by strategies.
  #
  # By Default it is set to User class.  If you need a different class
  # The intention is that you overwrite this method
  #
  # @return <User Class Object>
  #
  # @api overwritable
  cattr_writer :user_class
  def self.user_class
    @@user_class ||= User
  end
  
  def initialize(session)
    @session = session
  end
  
  # Returns true if there is an authenticated user attached to this session
  #
  # @return <TrueClass|FalseClass>
  # 
  def authenticated?
    !!user
  end
  
  # This method will retrieve the user object stored in the session or nil if there
  # is no user logged in.
  # 
  # @return <User class>|NilClass
  def user
    return nil if !session[:user]
    @user ||= fetch_user(session[:user])
  end
  
  # This method will store the user provided into the session
  # and set the user as the currently logged in user
  # @return <User Class>|NilClass
  def user=(user)
    session[:user] = nil && return if user.nil?
    session[:user] = store_user(user)
    @user = session[:user] ? user : session[:user]  
  end
  
  # The workhorse of the framework.  The authentiate! method is where
  # the work is done.  authenticate! will try each strategy in order
  # either passed in, or in the default_strategy_order.  
  #
  # If a strategy returns some kind of user object, this will be stored
  # in the session, otherwise a Merb::Controller::Unauthenticated exception is raised
  #
  # @params Merb::Request, [List,Of,Strategies, optional_options_hash]
  #
  # Pass in a list of strategy objects to have this list take precedence over the normal defaults
  # 
  # Use an options hash to provide an error message to be passed into the exception.
  #
  # @return user object of the verified user.  An exception is raised if no user is found
  #
  def authenticate!(request, *rest)
    opts = rest.last.kind_of?(Hash) ? rest.pop : {}
    rest = rest.flatten
    strategies = rest.empty? ? Authentication.default_strategy_order : rest

    msg = opts[:message] || error_message
    user = nil    
    # This one should find the first one that matches.  It should not run antother
    strategies.detect do |s|
      unless s.abstract?
        strategy = s.new(request)
        user = strategy.run! 
        if strategy.redirected?
          redirect!(strategy.redirect_url, strategy.redirect_options)
          return
        end
        user
      end
    end
    raise Merb::Controller::Unauthenticated, msg unless user
    session.user = user
  end
  
  # "Logs Out" a user from the session.  Also clears out all session data
  def abandon!
    @user = nil
    session.clear
  end
  
  # A simple error message mechanism to provide general information.  For more specific information
  #
  # This message is the default message passed to the Merb::Controller::Unauthenticated exception
  # during authentication.  
  #
  # This is a very simple mechanism for error messages.  For more detailed control see Authenticaiton#errors
  #
  # @api overwritable
  def error_message
    @error_message || "Could not log in"
  end
  
  # Tells the framework how to store your user object into the session so that it can be re-created 
  # on the next login.  
  # You must overwrite this method for use in your projects.  Slices and plugins may set this.
  #
  # @api overwritable
  def store_user(user)
    raise NotImplemented
  end
  
  # Tells the framework how to reconstitute a user from the data stored by store_user.
  #
  # You must overwrite this method for user in your projects.  Slices and plugins may set this.
  #
  # @api overwritable
  def fetch_user(session_contents = session[:user])
    raise NotImplemented
  end
end