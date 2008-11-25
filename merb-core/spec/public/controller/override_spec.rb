require File.join(File.dirname(__FILE__), "spec_helper")

class MyKontroller < Merb::Controller
end

describe "attempting to override a method in Merb::Controller" do
  after(:each) do
    MyKontroller.class_eval do
      undef_method :status if method_defined?(:status)
    end
  end
  
  it "raises an error" do
    lambda { MyKontroller.class_eval do
      def status
      end
    end }.should raise_error(Merb::ReservedError)
  end
  
  it "doesn't raise an error if override! is called" do
    lambda { MyKontroller.class_eval do
      override! :status
      def status
      end
    end }.should_not raise_error
  end
end