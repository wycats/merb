module Merb::Generators
  
  class ResourceControllerGenerator < ComponentGenerator
    
    desc <<-DESC
      This is a resource generator
    DESC
    
    option :testing_framework, :desc => 'Specify which testing framework to use (spec, test_unit)'
    option :orm, :desc => 'Specify which Object-Relation Mapper to use (none, activerecord, datamapper, sequel)'
    
    first_argument :name, :required => true
    
    #invoke Merb::ComponentGenerators::ResourceControllerTest
    
    template :controller do
      source("controller.rbt")
      destination("app/controllers/#{file_name}.rb")
    end
    
    template :helpers do
      source("helpers.rbt")
      destination("app/helpers/#{file_name}_helper.rb")
    end
    
    template :view_index, :orm => :none do
      source("views/index.html.erbt")
      destination("app/helpers/#{file_name}/index.rb")
    end
    
    template :view_show, :orm => :none do
      source("views/show.html.erbt")
      destination("app/helpers/#{file_name}/show.html.erb")
    end
    
    template :view_edit, :orm => :none do
      source("views/edit.html.erbt")
      destination("app/helpers/#{file_name}/edit.html.erb")
    end
    
    template :view_new, :orm => :none do
      source("views/new.html.erbt")
      destination("app/helpers/#{file_name}/new.html.erb")
    end
    
    def class_name
      self.name.camel_case
    end
    
    def test_class_name
      self.class_name + "Test"
    end
    
    def file_name
      self.name.snake_case
    end
    
    def source_root
      File.join(super, 'resource_controller')
    end
    
  end
  
  add :resource_controller, ResourceControllerGenerator
  
end