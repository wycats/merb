require File.dirname(__FILE__) + '/../spec_helper'

describe Merb::Test::Multipart::Param, '.to_multipart' do
  it "should represent the key and value correctly" do
    param = Merb::Test::Multipart::Param.new('foo', 'bar')
    param.to_multipart.should == %(Content-Disposition: form-data; name="foo"\r\n\r\nbar\r\n)
  end
end

describe Merb::Test::Multipart::FileParam, '.to_multipart' do
  it "should represent the key, filename and content correctly" do
    param = Merb::Test::Multipart::FileParam.new('foo', '/bar.txt', 'baz')
    param.to_multipart.should == %(Content-Disposition: form-data; name="foo"; filename="/bar.txt"\r\nContent-Type: text/plain\r\n\r\nbaz\r\n)
  end
end

describe Merb::Test::Multipart::Post, '.push_params(params) param parsing' do
  before(:each) do
    @fake_return_param = mock('fake return_param')
  end

  it "should create Param from params when param doesn't respond to read" do
    params = { 'normal' => 'normal_param' }
    Merb::Test::Multipart::Param.should_receive(:new).with('normal', 'normal_param').and_return(@fake_return_param)
    Merb::Test::Multipart::Post.new.push_params(params)
  end
  
  it "should create FileParam from params when param does response to read" do
    file_param = mock('file param')
    file_param.should_receive(:read).and_return('file contents')
    file_param.should_receive(:path).and_return('file.txt')
    params = { 'file' => file_param }
    Merb::Test::Multipart::FileParam.should_receive(:new).with('file', 'file.txt', 'file contents').and_return(@fake_return_param)
    Merb::Test::Multipart::Post.new.push_params(params)
  end
end
  
describe Merb::Test::Multipart::Post, '.to_multipart' do
  it "should create a multipart request from the params" do
    file_param = mock('file param')
    file_param.should_receive(:read).and_return('file contents')
    file_param.should_receive(:path).and_return('file.txt')
    params = { 'file' => file_param, 'normal' => 'normal_param' }
    multipart = Merb::Test::Multipart::Post.new(params)
    query, content_type = multipart.to_multipart
    content_type.should == "multipart/form-data, boundary=----------0xKhTmLbOuNdArY"
    query.should == "------------0xKhTmLbOuNdArY\r\nContent-Disposition: form-data; name=\"file\"; filename=\"file.txt\"\r\nContent-Type: text/plain\r\n\r\nfile contents\r\n------------0xKhTmLbOuNdArY\r\nContent-Disposition: form-data; name=\"normal\"\r\n\r\nnormal_param\r\n------------0xKhTmLbOuNdArY--"
  end
end
