class MerbAuthSlicePassword::Sessions < MerbAuthSlicePassword::Application
  
  before :_grab_return_to                       # Need to hang onto the redirection during the session.abandon!
  after  :_store_return_to_in_session           # Need to hang onto the redirection during the session.abandon!
  
  before(nil, :only => [:update, :destroy]) { session.abandon! }
  before :ensure_authenticated

  # redirect from an after filter for max flexibility
  # We can then put it into a slice and ppl can easily 
  # customize the action
  after :redirect_after_login,  :only => :update, :if => lambda{ !(300..399).include?(status) }
  after :redirect_after_logout, :only => :destroy
  
  def update
    "Add an after filter to do stuff after login"
  end

  def destroy
    "Add an after filter to do stuff after logout"
  end
  
  
  private   
  # @overwritable
  def redirect_after_login
    redirect_back_or "/", :message => "Authenticated Successfully", :ignore => [url(:login), url(:logout)]
  end
  
  # @overwritable
  def redirect_after_logout
    redirect "/", :message => "Logged Out"
  end  
  
  # @private
  def _grab_return_to
    session.authentication.return_to_url
  end

  # @private
  def _store_return_to_in_session
    session.authentication.return_to_url = session.authentication.return_to_url
  end
end