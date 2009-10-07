require File.dirname(__FILE__) + '/../../spec_helper'

describe "Kernel#caller" do
  it "should be able to determine caller info" do
    __caller_info__.should be_kind_of(Array)
  end

  it "should be able to get caller lines" do
    i = 0
    __caller_lines__(__caller_info__[0], __caller_info__[1], 4) { i += 1 }
    i.should == 9
  end
end


describe "Kernel#extract_options_from_args!" do
  it "should extract options from args" do
    args = ["foo", "bar", {:baz => :bar}]
    Kernel.extract_options_from_args!(args).should == {:baz => :bar}
    args.should == ["foo", "bar"]
  end
end