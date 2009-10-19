require 'spec_helper'
require 'dm-core'
require 'dm-validations'
require 'merb-auth-more/mixins/bcrypt_user'

describe "A DataMapper Bcrypt User" do

  include UserHelper

  before(:all) do

    DataMapper.setup(:default, "sqlite3::memory:")

    class DataMapperBcryptUser

      include DataMapper::Resource
      include Merb::Authentication::Mixins::BCryptUser

      property :id,    Serial
      property :email, String
      property :login, String

    end

    DataMapper.auto_migrate!

  end

  before(:each) do
    @user_class = DataMapperBcryptUser
    @user_class.create(valid_user_params)
    @new_user = @user_class.new(valid_user_params)
  end

  after(:each) do
    DataMapperBcryptUser.all.destroy!
  end

  it_should_behave_like 'every encrypted user'
  it_should_behave_like 'every bcrypt user'

end