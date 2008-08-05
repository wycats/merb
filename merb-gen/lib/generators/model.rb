module Merb::Generators
  
  class ModelGenerator < NamespacedGenerator

    def self.source_root
      File.join(super, 'model')
    end
    
    desc <<-DESC
      Generates a new model. You can specify an ORM different from what the rest
      of the application uses.
    DESC
    
    option :testing_framework, :desc => 'Testing framework to use (one of: spec, test_unit)'
    option :orm, :desc => 'Object-Relation Mapper to use (one of: none, activerecord, datamapper, sequel)'
    
    first_argument :name, :required => true, :desc => "model name"
    second_argument :attributes, :as => :hash, :default => {}, :desc => "space separated model properties in form of name:type. Example: state:string"
    
    invoke :migration do |generator|
      generator.new(destination_root, options.merge(:model => true), file_name, attributes)
    end
    
    [:none, :activerecord, :sequel, :datamapper].each do |orm|
    
      template "model_#{orm}".to_sym, :orm => orm do
        source("#{orm}/app/models/%file_name%.rb")
        destination("app/models", base_path, "#{file_name}.rb")
      end
    
    end
    
    template :spec, :testing_framework => :rspec do
      source('rspec/spec/models/%file_name%_spec.rb')
      destination("spec/models", base_path, "#{file_name}_spec.rb")
    end
    
    template :test_unit, :testing_framework => :test_unit do
      source('test_unit/test/models/%file_name%_test.rb')
      destination("test/models", base_path, "#{file_name}_test.rb")
    end
    
    def attributes?
      self.attributes && !self.attributes.empty?
    end
    
    def attributes_for_accessor
      self.attributes.keys.map{|a| ":#{a}" }.compact.uniq.join(", ")
    end
    
  end
  
  add :model, ModelGenerator
  
end
