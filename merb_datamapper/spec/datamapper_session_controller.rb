class Session < Application
  def set
    session[:key] = 'value'
  end

  def get
    session[:key]
  end
end
