Merb::Router.prepare do |r|
  r.match('/').to(:controller => '<%= app_file_name %>', :action =>'index')
end

class <%= app_file_name.camel_case %> < Merb::Controller
  def index
    "hi"
  end
end

Merb::Config.use { |c|
  c[:framework]           = {},
  c[:session_store]       = 'none',
  c[:exception_details]   = true
}