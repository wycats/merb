require File.dirname(__FILE__) + '/spec_helper'

describe Merb::Slices do
  
  before(:all) do
    # Add the slice to the search path
    Merb::Plugins.config[:merb_slices][:auto_register] = true
    Merb::Plugins.config[:merb_slices][:search_path]   = File.dirname(__FILE__) / 'slices'
    
    Merb.start(
      :testing => true, 
      :adapter => 'runner', 
      :environment => ENV['MERB_ENV'] || 'test',
      :merb_root => Merb.root
    )
  end
  
  before :all do
    Merb::Router.prepare do 
      all_slices
    end
  end
  
  after :all do
    Merb::Router.reset!
  end
  
  it "should be registered in Merb::Slices.slices" do
    Merb::Slices.slices.should include(FullTestSlice)
    Merb::Slices.slices.should include(ThinTestSlice)
    Merb::Slices.slices.should include(VeryThinTestSlice)
  end
  
end