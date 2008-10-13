$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require "rubygems"
require "merb-core"
require "spec"
require "merb_exceptions"

# merb-exceptions needs to include itself into this class
class Exceptions < Merb::Controller; end

Merb::Plugins.config[:exceptions][:environments] = 'test'
Merb.start :environment => 'test'

module NotificationSpecHelper
  def mock_details(opts={})
    {
      'exception'      => {},
      'params'         => { :controller=>'errors', :action=>'show' },
      'environment'    => { 'key1'=>'value1', 'key2'=>'value2' },
      'url'            => 'http://www.my-app.com/errors/1'
    }.merge(opts)
  end
  
  def mock_merb_config(opts={})
    Merb::Plugins.config[:exceptions].merge!(opts)
  end
end