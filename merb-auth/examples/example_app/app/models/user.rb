class User 
  include DataMapper::Resource 

  property :id,               Serial
  property :login,            String
  property :email,            String
  property :crypted_password, String, :length => 150
  property :salt,             String, :length => 150
  property :active,           Boolean, :default => false
  property :identity_url,     String
  
  validates_present   :login, :email
  validates_is_unique :login, :email
  validates_format    :email, :as => :email_address
  
  attr_accessor :password, :password_confirmation
  validates_is_confirmed :password
  
  before :save, :encrypt_password
  
  def active?
    !!self.active
  end

  def self.encrypt(salt, password = nil)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end
  
  def self.authenticate(login, password)
    u = self.first(:login => login)
    return nil unless u
    u.crypted_password == encrypt(u.salt, password) ? u : nil
  end
  
  def encrypt_password
    self.salt ||= Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--")
    self.crypted_password ||= User.encrypt(salt, password)  
  end
  
end