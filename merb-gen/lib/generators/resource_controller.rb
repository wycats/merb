module Merb::Generators
  
  class ResourceControllerGenerator < NamespacedGenerator

    def self.source_root
      File.join(super, 'component', 'resource_controller')
    end
    
    desc <<-DESC
      Generates a new resource controller.
    DESC
    
    option :testing_framework, :desc => 'Testing framework to use (one of: rspec, test_unit)'
    option :orm, :desc => 'Object-Relation Mapper to use (one of: none, activerecord, datamapper, sequel)'
    option :template_engine, :desc => 'Template Engine to use (one of: erb, haml, markaby, etc...)'
    
    first_argument :name, :required => true,
                          :desc     => "model name"
    second_argument :attributes, :as      => :hash,
                                 :default => {},
                                 :desc    => "space separated resource model properties in form of name:type. Example: state:string"
    
    invoke :helper do |generator|
      generator.new(destination_root, options, name)
    end
    
    # add controller and view templates for each of the four big ORM's

    
    template :controller_none, :orm => :none do |template|
      template.source = "app/controllers/%file_name%.rb"
      template.destination = "app/controllers" / base_path / "#{file_name}.rb"
    end
  
    [:index, :show, :edit, :new].each do |view|
      template "view_#{view}_none".to_sym, :orm => :none do |template|
        template.source = "app/views/%file_name%/#{view}.html.erb"
        template.destination = "app/views" / base_path / "#{file_name}/#{view}.html.erb"
      end
    end
    
    template :controller_spec, :testing_framework => :rspec, :orm => :none do |template|
      template.source = 'spec/controllers/%file_name%_spec.rb'
      template.destination = "spec/controllers" / base_path / "#{file_name}_spec.rb"
    end
    
    template :controller_test_unit, :testing_framework => :test_unit, :orm => :none do |template|
      template.source = 'test/controllers/%file_name%_test.rb'
      template.destination = "test/controllers" / base_path / "#{file_name}_test.rb"
    end
    
    def model_class_name
      class_name.singularize
    end
    
    def plural_model
      class_name.snake_case
    end
    
    def singular_model
      plural_model.singularize
    end
    
    def resource_path
      chunks.map{ |c| c.snake_case }.join('/')
    end
    
    # TODO: fix this for Datamapper, so that it returns the primary keys for the model
    def params_for_get
      "params[:id]"
    end
    
    # TODO: implement this for Datamapper so that we get the model properties
    def properties
      []
    end
    
  end
  
  add :resource_controller, ResourceControllerGenerator
  
end
