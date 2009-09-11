require File.join(File.dirname(__FILE__), "spec_helper")
startup_merb

$:.push File.join(File.dirname(__FILE__), "fixtures")

describe Kernel, "#use_orm" do
  
  before do
    Kernel.stub!(:dependency)
    Merb.orm = :none # reset orm
  end
  
  it "should set Merb.orm" do
    Kernel.use_orm(:activerecord)
    Merb.orm.should == :activerecord
  end
  
  it "should not add dependency" do
    Kernel.should_not_receive(:dependency)
    Kernel.use_orm(:activerecord)
  end

end

describe Kernel, "#use_template_engine" do
  
  before do
    Kernel.stub!(:dependency)
    Merb.template_engine = :erb # reset template engine
  end
  
  it "should set Merb.template_engine" do
    Kernel.use_template_engine(:haml)
    Merb.template_engine.should == :haml
  end
  
  it "should add no dependency" do
    Kernel.should_not_receive(:dependency)
    Kernel.use_template_engine(:haml)
  end
end

describe Kernel, "#use_test" do
  
  before do
    Merb.stub!(:dependencies)
    Merb.test_framework = :rspec # reset test framework
  end
  
  it "should set Merb.test_framework" do
    Kernel.use_test(:test_unit)
    Merb.test_framework.should == :test_unit
  end
  
  it "should not require test dependencies when not in 'test' env" do
    Merb.stub!(:env).and_return("development")
    Kernel.should_not_receive(:dependencies)
    Merb.use_test(:test_unit, 'hpricot', 'webrat')
  end
  
  it "should nor require test dependencies when in 'test' env" do
    Merb.stub!(:env).and_return("test")
    Kernel.should_not_receive(:dependencies)
    Merb.use_test(:test_unit, 'hpricot', 'webrat')
  end
  
end
