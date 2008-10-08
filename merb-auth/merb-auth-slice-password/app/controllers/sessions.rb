class MerbAuthSlicePassword::Sessions < MerbAuthSlicePassword::Application
  
  before(nil, :only => [:update, :destroy]) { session.abandon! }
  before :ensure_authenticated

  # redirect from an after filter for max flexibility
  # We can then put it into a slice and ppl can easily 
  # customize the action
  after :redirect_after_login,  :only => :update, :if => lambda{ puts "THE STATUS IS #{status}"; !(300..399).include?(status) }
  after :redirect_after_logout, :only => :destroy
  
  def update
    "Add an after filter to do stuff after login"
  end

  def destroy
    "Add an after filter to do stuff after logout"
  end
  
  
  private 
  def redirect_after_login
    redirect "/", :message => "Authenticated Successfully"
  end
  
  def redirect_after_logout
    raise Unauthenticated, "Thank you, come again - Apu Nahasapeemapetilon"
  end  
end