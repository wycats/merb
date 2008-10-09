require File.join(File.dirname(__FILE__), 'spec_helper')
require File.join(File.dirname(__FILE__), '..', 'lib', 'merb', 'orms', 'data_mapper', 'connection')

describe 'Merb datamapper' do
  it "should read the configuration file" do

  end

  it 'should return an option hash with symbol keys' do
    Merb.should_receive(:environment).once.and_return('development')

    config = {
      'development' => {
        'adapter'      => 'myadapter',
        'more_stuff'   => 'more_stuff',
        'repositories' => {
          'repo1' => {
            'adapter' => 'mysql',
          },
        },
      },
    }

    Merb::Orms::DataMapper.should_receive(:full_config).once.and_return(config)
    Merb::Orms::DataMapper.config.should have_key(:adapter)
    Merb::Orms::DataMapper.config[:adapter].should == 'myadapter'
    Merb::Orms::DataMapper.config.should have_key(:repositories)
    Merb::Orms::DataMapper.config[:repositories].should have_key(:repo1)
    Merb::Orms::DataMapper.config[:repositories][:repo1].should have_key(:adapter)
    Merb::Orms::DataMapper.config[:repositories][:repo1][:adapter].should == 'mysql'
  end

  it "should create a default repository" do
    config = {
      :adapter => 'mysql',
      :database => 'mydb'
    }

    Merb::Orms::DataMapper.should_receive(:config).and_return(config)
    DataMapper.should_receive(:setup).with(:default, config)

    Merb::Orms::DataMapper.setup_connections
  end

  it "should create additional repositories" do
    conf_mysql = {
      :adapter => "mysql",
      :database => "db"
    }
    conf_postgres = {
      :adapter => "postgres",
      :database => "dbp"
    }
    config = {
      :repositories => {
        :repo1 => conf_mysql,
        :repo2 => conf_postgres
      }
    }

    Merb::Orms::DataMapper.should_receive(:config).and_return(config)
    DataMapper.should_receive(:setup).with(:repo1, conf_mysql)
    DataMapper.should_receive(:setup).with(:repo2, conf_postgres)

    Merb::Orms::DataMapper.setup_connections
  end
end
