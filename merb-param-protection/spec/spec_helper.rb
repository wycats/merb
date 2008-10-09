require 'rubygems'
$:.push File.join(File.dirname(__FILE__), '..', 'lib')
require 'merb-core'
require 'merb_param_protection'

Spec::Runner.configure do |config|
  config.include(Merb::Test::ViewHelper)
  config.include(Merb::Test::RouteHelper)
  config.include(Merb::Test::ControllerHelper)
end

def new_controller(action = 'index', controller = nil, additional_params = {})
  request = OpenStruct.new
  request.params = {:action => action, :controller => (controller.to_s || "Test")}
  request.params.update(additional_params)
  request.cookies = {}
  request.accept ||= '*/*'
  
  yield request if block_given?
  
  response = OpenStruct.new
  response.read = ""
  (controller || Merb::Controller).build(request, response)
end

class Merb::Controller
  # require 'merb/session/memory_session'
  # Merb::MemorySessionContainer.setup
  # include ::Merb::SessionMixin
  # self.session_secret_key = "footo the bar to the baz"
end