module Merb::Generators
  
  class PartControllerGenerator < ComponentGenerator
    
    desc <<-DESC
      This is a part controller generator
    DESC
    
    first_argument :name, :required => true
    
    template :controller do
      source('controller.rbt')
      destination("app/parts/#{file_name}_part.rb")
    end
    
    template :helpers do
      source('helper.rbt')
      destination("app/helpers/#{file_name}_part_helper.rb")
    end
    
    template :index do
      source('index.html.erbt')
      destination("app/parts/views/#{file_name}_part/index.html.erb")
    end
    
    def controller_modules
      chunks[0..-2]
    end
    
    def controller_class_name
      chunks.last
    end
    
    def full_class_name
      chunks.join('::')
    end
    
    def file_name
      controller_class_name.snake_case
    end
    
    def source_root
      File.join(super, 'part_controller')
    end
    
    protected
    
    def chunks
      name.gsub('/', '::').split('::').map { |c| c.camel_case }
    end
    
  end
  
  add :part, PartControllerGenerator
  
end