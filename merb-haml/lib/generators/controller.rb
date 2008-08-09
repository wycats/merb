Merb::Generators::ControllerGenerator.template :index_haml, :template_engine => :haml do
  source(File.dirname(__FILE__), 'templates/controller/app/views/%file_name%/index.html.haml')
  destination("app/views", base_path, "#{file_name}/index.html.haml")
end