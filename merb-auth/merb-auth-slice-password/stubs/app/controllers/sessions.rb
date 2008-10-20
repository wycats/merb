class MerbAuthSlicePassword::Sessions < MerbAuthSlicePassword::Application

  after :redirect_after_login,  :only => :update, :if => lambda{ !(300..399).include?(status) }
  after :redirect_after_logout, :only => :destroy

  private   
  # @overwritable
  def redirect_after_login
    redirect_back_or "/", :message => "Authenticated Successfully", :ignore => [url(:login), url(:logout)]
  end

  # @overwritable
  def redirect_after_logout
    redirect "/", :message => "Logged Out"
  end
  
end