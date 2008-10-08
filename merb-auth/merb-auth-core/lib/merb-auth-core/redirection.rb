class Authentication
  
  def redirected?
    !!(@redirect_url)
  end
  
  def redirect!(url, opts = {})
    @redirect_options = opts
    @redirect_url = url
  end
  
  def redirect_url
    @redirect_url
  end
  
  def redirect_options
    @redirect_options || {}
  end
  
  def redirect_status
    return @redirect_options[:status] if @redirect_options[:status]
    @redirect_options[:permanent].blank? ? 302 : 301
  end
  
end