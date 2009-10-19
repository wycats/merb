require File.dirname(__FILE__) + '/spec_helper'

module UserHelper

  def valid_login
    'fred'
  end

  def valid_email
    'fred@example.com'
  end

  def valid_password
    'sekrit'
  end

  def valid_user_params
    {
      :login                 => valid_login,
      :email                 => valid_email,
      :password              => valid_password,
      :password_confirmation => valid_password
    }
  end

end

describe "every encrypted user", :shared => true do

  describe "class" do

    it "should authenticate valid credentials" do
      @user_class.authenticate(valid_login, valid_password).should_not be_nil
    end

    it "should not authenticate an invalid login and an existing password" do
      @user_class.authenticate("not_the_login", valid_password).should be_nil
    end

    it "should not authenticate a valid login and an invalid password" do
      @user_class.authenticate(valid_login, "not_the_password").should be_nil
    end

    it "should not authenticate an invalid login and an unknown password" do
      @user_class.authenticate("i_dont_exist", "not_the_password").should be_nil
    end

  end

  describe "instance" do

    it { @new_user.should respond_to(:password)              }
    it { @new_user.should respond_to(:password_confirmation) }
    it { @new_user.should respond_to(:crypted_password)      }

    it "should require a password if a #password_required? returns true" do
      @new_user.password = nil
      @new_user.password_required?.should be_true
      @new_user.should_not be_valid
    end

    it "should require a password_confirmation if #password_required? returns true" do
      @new_user.password_confirmation = nil
      @new_user.password_required?.should be_true
      @new_user.should_not be_valid
    end

    it "should not require a password when saving an existing user" do
      user = @user_class.first(:login => valid_login)
      user.password.should be_nil
      user.password_confirmation.should be_nil
      user.login = "some_different_login_to_allow_saving"
      user.save
    end

    it "should authenticate a user instance against a valid password" do
      @user_class.first(:login => valid_login).should be_authenticated(valid_password)
    end

  end

end

describe 'every salted user', :shared => true do

  it { @new_user.should respond_to(:salt) }

  it "should set the salt" do
    @new_user.salt.should be_nil
    @new_user.send(:encrypt_password)
    @new_user.salt.should_not be_nil    
  end

  it "should set the salt even when user is not new record but salt is blank" do
    @new_user.save
    @new_user.salt = nil
    @new_user.send(:encrypt_password)
    @new_user.salt.should_not be_nil
  end

end

describe 'every bcrypt user', :shared => true do

  it "should create a valid Bcrypt password" do
    lambda { @new_user.bcrypt_password }.should raise_error(BCrypt::Errors::InvalidHash)
    @new_user.send(:encrypt_password)
    lambda { @new_user.bcrypt_password }.should_not raise_error(BCrypt::Errors::InvalidHash)
  end

  it "should use the cost set in Merb::Plugins.config[:'merb-auth'][:bcrypt_cost]" do
    Merb::Plugins.config[:'merb-auth'][:bcrypt_cost] = 6
    @new_user.send(:encrypt_password)
    @new_user.bcrypt_password.cost.should == 6
  end

end