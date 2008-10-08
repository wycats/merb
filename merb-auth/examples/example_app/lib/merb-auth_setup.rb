class Authentication
  
  def store_user(user)
    return nil unless user
    user.id
  end
  
  def fetch_user(session_info)
    User.get(session_info)
  end
    
end # Authentication