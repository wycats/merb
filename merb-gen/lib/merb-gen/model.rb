module Merb::ComponentGenerators
  
  class ModelGenerator < ComponentGenerator
    
    option :testing_framework, :default => :rspec, :desc => 'Specify which testing framework to use (spec, test_unit)'
    
    first_argument :name, :required => true
    second_argument :attributes, :as => :hash
    
    template :model do
      source('model.rbt')
      destination('app/models/' + file_name + '.rb')
    end
    
    def class_name
      self.name.camel_case
    end
    
    def file_name
      self.name.snake_case
    end
    
    def attributes?
      self.attributes && !self.attributes.empty?
    end
    
    def attributes_for_accessor
      self.attributes.map{|a| ":#{a.first}" }.compact.uniq.join(", ")
    end
    
    def source_root
      File.join(super, 'model')
    end
    
  end
  
  add :model, ModelGenerator
  
end