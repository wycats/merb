require File.join(File.dirname(__FILE__), "..", 'spec_helper.rb')
require 'dm-core'
require 'dm-validations'
require File.join(File.expand_path(File.dirname(__FILE__)), "..", ".." ,"lib", "merb-auth-more", "strategies", "abstract_password")
require File.join(File.expand_path(File.dirname(__FILE__)), "..", ".." ,"lib", "merb-auth-more", "mixins", "bcrypt_user")

describe "A Bcrypt User" do
  
  before(:all) do
    DataMapper.setup(:default, "sqlite3::memory:")
    
    class Utilisateur
      include DataMapper::Resource
      include Merb::Authentication::Mixins::BCryptUser
      
      property :id, Serial
      property :email, String
      property :login, String
    end
    Utilisateur.auto_migrate!
  end
  
  after(:each) do
    Utilisateur.all.destroy!
  end
  
  def default_user_params
    {:login => "fred", :email => "fred@example.com", :password => "sekrit", :password_confirmation => "sekrit"}
  end
  
  it "should authenticate a user using a class method" do
    user = Utilisateur.new(default_user_params)
    user.save
    user.should_not be_new_record
    Utilisateur.authenticate("fred", "sekrit").should_not be_nil
  end
  
  it "should not authenticate a user using the wrong password" do
    user = Utilisateur.new(default_user_params)  
    user.save
    Utilisateur.authenticate("fred", "not_the_password").should be_nil
  end
  
  it "should not authenticate a user using the wrong login" do
    user = Utilisateur.create(default_user_params)  
    Utilisateur.authenticate("not_the_login@blah.com", "sekrit").should be_nil
  end
  
  it "should not authenticate a user that does not exist" do
    Utilisateur.authenticate("i_dont_exist", "password").should be_nil
  end
  
  describe "passwords" do
    before(:each) do
      @user = Utilisateur.new(default_user_params)
    end
    
    it{@user.should respond_to(:password)}
    it{@user.should respond_to(:password_confirmation)}
    it{@user.should respond_to(:crypted_password)}
    it{@user.should_not respond_to(:salt)}
    
    
    it "should require password if password is required" do
      user = Utilisateur.new(:login => "fred", :email => "fred@example.com")
      user.stub!(:password_required?).and_return(true)
      user.valid?
      user.errors.on(:password).should_not be_nil
      user.errors.on(:password).should_not be_empty
    end
    
    it "should create a valid Bcrypt password" do
      lambda { @user.bcrypt_password }.should raise_error(BCrypt::Errors::InvalidHash)
      @user.send(:encrypt_password)
      lambda { @user.bcrypt_password }.should_not raise_error(BCrypt::Errors::InvalidHash)
    end
    
    it "should require the password on create" do
      user = Utilisateur.new(:login => "fred", :email => "fred@example.com")
      user.password_required?.should be_true
      user.save
      user.errors.on(:password).should_not be_nil
      user.errors.on(:password).should_not be_empty
    end
    
    it "should require password_confirmation if the password_required?" do
      user = Utilisateur.new(:login => "fred", :email => "fred@example.com", :password => "sekrit")
      user.save
      (user.errors.on(:password) || user.errors.on(:password_confirmation)).should_not be_nil
    end
     
    it "should autenticate against a password" do
      @user.save    
      @user.should be_authenticated("sekrit")
    end
    
    it "should not require a password when saving an existing user" do
      @user.save
      @user.should_not be_a_new_record
      @user = Utilisateur.first(:login => "fred")
      @user.password.should be_nil
      @user.password_confirmation.should be_nil
      @user.login = "some_different_login_to_allow_saving"
      (@user.save).should be_true
    end
    
    it "should use the cost set in Merb::Plugins.config[:'merb-auth'][:bcrypt_cost]" do
      Merb::Plugins.config[:'merb-auth'][:bcrypt_cost] = 6
      @user.send(:encrypt_password)
      @user.bcrypt_password.cost.should == 6
    end
  end  
end