require File.join(File.dirname(__FILE__), 'spec_helper')

require 'merb/session/data_mapper_session'
describe Merb::DataMapperSessionStore do
  before(:all) do
    DataMapper.setup(:default, "sqlite3::memory:")
  end

  before(:each) do
    Merb::Plugins.config[:merb_datamapper] = {}
    @session_container = Merb::DataMapperSessionStore
    @session_container.auto_migrate!
    @sess_id = 'a'*32
  end


  describe "#retrieve_session" do
    it "responds to retrieve_session" do
      @session_container.should respond_to(:retrieve_session)
    end
    it "returns the data when given an existing session id" do
      @session_container.create(:session_id => @sess_id, :data => {:foo => 'bar'})
      session_data = @session_container.retrieve_session(@sess_id)
      session_data.should_not be_nil
      session_data[:foo].should == 'bar'
    end
    it "returns nil when a non-existent session_id is used" do
      @session_container.retrieve_session(@sess_id).should be_nil
    end
  end


  describe "#store_session" do
    it "responds to store_session" do
      @session_container.should respond_to(:store_session)
    end

    describe "when a session_id doesn't exist" do
      it "creates a new record" do
      @session_container.all.should be_empty
      @session_container.store_session(@sess_id, {:foo => 'bar'})
      @session_container.all.should_not be_empty
      end

      it "saves the data" do
        @session_container.store_session(@sess_id, {:foo => 'bar'})
        session_data = @session_container.retrieve_session(@sess_id)
        session_data.should_not be_nil
        session_data[:foo].should == 'bar'
      end
    end

    describe "when a session_id does exist" do
      before(:each) do
        @session_container.store_session(@sess_id, {:foo => 'bar'})
      end

      it "doesn't create a new session" do
        @session_container.all.size.should == 1
        @session_container.store_session(@sess_id, {:foo => 'FOOOO'})
        @session_container.all.size.should == 1
      end

      it "saves the data" do
        @session_container.store_session(@sess_id, {:foo => 'FOOOO'})
        session_data = @session_container.retrieve_session(@sess_id)
        session_data.should_not be_nil
        session_data[:foo].should == 'FOOOO'
      end
    end
  end


  describe "#delete_session" do
    before(:each) do
      @session_container.store_session(@sess_id, {:foo => 'bar'})
    end

    it "responds to #delete_session" do
      @session_container.should respond_to(:delete_session)
    end

    it "destroys an existing session" do
      @session_container.all.size.should == 1
      @session_container.delete_session(@sess_id)
      @session_container.all.size.should == 0
    end

    it "doesn't destroy a session when the key doesn't match" do
      @session_container.all.size.should == 1
      @session_container.delete_session('b'*32)
      @session_container.all.size.should == 1
    end
  end
end
describe "configuration options" do
  before(:each) do
    @session_container = Merb::DataMapperSessionStore
  end
  after(:each) do
    Merb::Plugins.config[:merb_datamapper].clear
  end

  describe "repository" do
    it "uses the :default repository when no options are set" do
      @session_container.default_repository_name.should == :default
    end
    it "uses the set name when provided" do
      Merb::Plugins.config[:merb_datamapper][:session_repository_name] = :other
      @session_container.default_repository_name.should == :other
    end
  end


  describe "table name" do
    it "uses the 'sessions'  when no options are set" do
      @session_container.storage_names[:default].should == 'sessions'
    end
    it "uses the set table name when it is set" do
      pending "this should work but doesn't"
      Merb::Plugins.config[:merb_datamapper][:session_storage_name] = 'foos'
      @session_container.storage_names[:default].should == 'foos'
    end
  end
end
