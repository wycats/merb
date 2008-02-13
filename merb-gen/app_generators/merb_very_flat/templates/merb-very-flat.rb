Merb::Router.prepare do |r|
  r.match('/').to(:controller => 'foo', :action =>'index')
end

class Foo < Merb::Controller
  def index
    "hi"
  end
end

Merb::Config.use { |c|
  c[:framework]           = {},
  c[:session_store]       = 'none',
  c[:exception_details]   = true
}