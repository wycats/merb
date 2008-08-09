Merb::Generators::LayoutGenerator.template :layout_haml, :template_engine => :haml do
  source(File.dirname(__FILE__), 'templates/layout/app/views/layout/%file_name%.html.haml')
  destination("app/views/layout/#{file_name}.html.haml")
end