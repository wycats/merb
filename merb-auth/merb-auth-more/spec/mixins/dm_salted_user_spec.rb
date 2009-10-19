require 'spec_helper'
require 'dm-core'
require 'dm-validations'
require 'merb-auth-more/mixins/salted_user'

describe "A DataMapper Salted User" do

  include UserHelper
  
  before(:all) do

    DataMapper.setup(:default, "sqlite3::memory:")
    
    class DataMapperSaltedUser

      include DataMapper::Resource
      include Merb::Authentication::Mixins::SaltedUser
      
      property :id,    Serial
      property :email, String
      property :login, String

    end

    DataMapper.auto_migrate!

  end

  before(:each) do
    @user_class = DataMapperSaltedUser
    @user_class.create(valid_user_params)
    @new_user = @user_class.new(valid_user_params)
  end

  after(:each) do
    DataMapperSaltedUser.all.destroy!
  end

  it_should_behave_like 'every encrypted user'
  it_should_behave_like 'every salted user'

end
