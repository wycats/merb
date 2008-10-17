# Impelments redirect_back_or.  i.e. remembers where you've come from on a failed login
# and stores this inforamtion in the session.  When you're finally logged in you can use
# the redirect_back_or helper to redirect them either back where they came from, or a pre-defined url.
# 
# Here's some examples:
#
#  1. User visits login form and is logged in
#     - redirect to the provided (default) url
#
#  2. User vists a page (/page) and gets kicked to login (raised Unauthenticated)
#     - On successful login, the user may be redirect_back_or("/home") and they will 
#       return to the /page url.  The /home  url is ignored
#
#

#
module Merb::AuthenticatedHelper
  
  # Add a helper to do the redirect_back_or  for you.  Also tidies up the session afterwards
  # If there has been a failed login attempt on some page using this method
  # you'll be redirected back to that page.  Otherwise redirect to the default_url
  #
  # To make sure you're not redirected back to the login page after a failed then successful login,
  # you can include an ignore url.  Basically, if the return url == the ignore url go to the default_url
  #
  # set the ignore url via an :ignore option in the opts hash.
  def redirect_back_or(default_url, opts = {})
    if session.authentication.return_to_url && ![opts[:ignore]].flatten.include?(session.authentication.return_to_url)
      redirect session.authentication.return_to_url, opts
    else
      redirect default_url, opts
    end
    session.authentication.return_to_url = nil
    "Redirecting to <a href='#{default_url}'>#{default_url}</a>"
  end
  
end


class Application < Merb::Controller; end

class Exceptions < Application
  after  :_set_return_to,   :only => :unauthenticated

  private   
  def _set_return_to
    session.authentication.return_to_url ||= request.uri unless request.exceptions.blank?
  end
end

class Merb::Authentication

  def return_to_url
    @return_to_url ||= session[:return_to]
  end
  
  def return_to_url=(return_url)
    @return_to_url = session[:return_to] = return_url
  end
end