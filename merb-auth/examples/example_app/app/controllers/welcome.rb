class Welcome < Application
  before :ensure_authenticated
  
  def index
    "We're In #{request.full_uri}"
  end
  
end