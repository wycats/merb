require File.dirname(__FILE__) + '/spec_helper'

describe "merb-actionorm" do
  
   shared_examples_for "a supported ORM" do
     it "should support the orm" do
       ActionORM.supports?(@model_instance).should be_true
     end

     it "should know if a record is a new record or not" do
       ActionORM.for(@model_instance).new_record?.should be_true
       @model_instance.save
       ActionORM.for(@model_instance).new_record?.should be_false      
     end
   end
  
  describe "test ORM" do
    before(:each) do
      ActionORM.use :orm => :test_orm
      @model_instance = ActionORM::TestORMModel.new
    end
    it_should_behave_like "a supported ORM"
  end
  
  describe "sequel ORM" do
    before(:all) do
      ActionORM.use :orm => :sequel_orm
      DB = Sequel.sqlite
      DB.create_table :sequel_models do
        primary_key :id
        column :name, :text
      end
      class SequelModel < Sequel::Model
        validates_presence_of :name
      end
    end
    before(:each) do
      @model_instance = SequelModel.new(:name => "Matt")
    end
    it_should_behave_like "a supported ORM"
    
    it "should know if a record is valid or not" do
      ActionORM.for(@model_instance).valid?.should be_true
      @model_instance.name = nil
      ActionORM.for(@model_instance).valid?.should be_false
    end
  end

  # describe "ActiveRecord ORM" do
  #   before(:all) do
  #     ActiveRecord::Base.establish_connection({'adapter' => 'sqlite3', 'database' => 'actionorm-test.sqlite3'})
  #     class AddName < ActiveRecord::Migration
  #       def self.up
  #       end
  #     end
  #     ActiveRecord::Migrator.migrate("ar/migrations")
  #     ActionORM.use :orm => :active_record
  #     class ARModel < ActiveRecord::Base; end
  #   end
  #   before(:each) do
  #     @model_instance = ARModel.new(:name => 'Matt')
  #   end
  #   it_should_behave_like "a supported ORM"
  #   
  #   it "should know if a record is valid or not" do
  #     ActionORM.for(@model_instance).valid?.should be_true
  #     @model_instance.name = nil
  #     ActionORM.for(@model_instance).valid?.should be_false
  #   end
  # end
  
  describe "DataMapper ORM" do
    before(:all) do
      ActionORM.use :driver => nil, :for => DataMapper::Resource
      DataMapper.setup(:default, 'sqlite3::memory:')
      class DMModel
        include DataMapper::Resource
        property :id, Serial
        property :name, String
        validates_present :name
      end
      DataMapper.auto_migrate!
    end
    before(:each) do
      @model_instance = DMModel.new(:name => 'Matt')
    end
    it_should_behave_like "a supported ORM"
    
    it "should know if a record is valid or not" do
      ActionORM.for(@model_instance).valid?.should be_true
      @model_instance.name = nil
      ActionORM.for(@model_instance).valid?.should be_false
    end
  end
  
end