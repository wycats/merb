require File.join(File.dirname(__FILE__), "..", 'spec_helper.rb')
require 'sequel'
require 'merb_sequel'
require File.join(File.expand_path(File.dirname(__FILE__)), "..", ".." ,"lib", "merb-auth-more", "strategies", "abstract_password")
require File.join(File.expand_path(File.dirname(__FILE__)), "..", ".." ,"lib", "merb-auth-more", "mixins", "salted_user")

DB = Sequel.sqlite 

DB.drop_table(:utilisateurs) if DB.table_exists? :utilisateurs
DB.create_table :utilisateurs do
  primary_key :id
  column      :email,            :string
  column      :login,            :string
  column      :crypted_password, :string
  column      :salt,             :string
end

class Utilisateur < Sequel::Model
  set_dataset :utilisateurs
  plugin(:validation_helpers) if Merb::Orms::Sequel.new_sequel?
  include Merb::Authentication::Mixins::SaltedUser
end

describe "A Salted User" do
  
  after(:each) do
    Utilisateur.delete
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
    
    it "should require password if password is required" do
      user = Utilisateur.new(:login => "fred", :email => "fred@example.com")
      user.stub!(:password_required?).and_return(true)
      user.valid?
      user.errors.on(:password).should_not be_nil
      user.errors.on(:password).should_not be_empty
    end
    
    it "should set the salt" do
      @user.salt.should be_nil
      @user.send(:encrypt_password)
      @user.salt.should_not be_nil    
    end
    
    it "should require the password on create" do
      user = Utilisateur.new(:login => "fred", :email => "fred@example.com")
      user.should_not be_valid
      user.errors.on(:password).should_not be_nil
      user.errors.on(:password).should_not be_empty
    end
    
    it "should require password_confirmation if the password_required?" do
      user = Utilisateur.new(:login => "fred", :email => "fred@example.com", :password => "sekrit")
      user.should_not be_valid
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
    
  end  
end
