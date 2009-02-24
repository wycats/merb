require File.expand_path(File.join(File.dirname(__FILE__), "spec_helper"))

given "we set an ivar" do
  @foo = 7
end

given "we set another ivar" do
  @pi = 3.14
end

describe "a spec that reuses a given block", :given => "we set an ivar" do
  it "sees the results of the given block" do
    @foo.should == 7
  end
end

describe "a spec that reuses many given blocks", :given => ["we set an ivar", "we set another ivar"] do
  it "sees the results of the first given block" do
    @foo.should == 7
  end

  it "sees the results of the second given block" do
    @pi.should == 3.14
  end
end

describe "a spec that does not reuse a given block" do
  it "does not see the given block" do
    @foo.should == nil
  end
end