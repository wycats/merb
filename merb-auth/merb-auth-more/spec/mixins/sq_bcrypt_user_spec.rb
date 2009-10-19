require 'spec_helper'
require 'sequel'
require 'merb_sequel'
require 'merb-auth-more/mixins/bcrypt_user'

DB = Sequel.sqlite unless Object.const_defined?('DB')

describe "A Sequel Bcrypt User" do
  
  include UserHelper
  
  before(:all) do

    DB.drop_table(:users) if DB.table_exists? :users
    DB.create_table :users do
      primary_key :id
      column      :email,            :string
      column      :login,            :string
      column      :crypted_password, :string
    end

    class SequelBcryptUser < Sequel::Model
      set_dataset :users
      plugin(:validation_helpers) if Merb::Orms::Sequel.new_sequel?
      include Merb::Authentication::Mixins::BCryptUser
    end

  end

  before(:each) do
    @user_class = SequelBcryptUser
    @user_class.create(valid_user_params)
    @new_user = @user_class.new(valid_user_params)
  end

  after(:each) do
    SequelBcryptUser.delete
  end

  it_should_behave_like 'every encrypted user'
  it_should_behave_like 'every bcrypt user'

end