module Merb::Generators
  
  class ModelGenerator < ComponentGenerator

    def self.source_root
      File.join(super, 'model')
    end
    
    desc <<-DESC
      This is a model generator
    DESC
    
    option :testing_framework, :desc => 'Specify which testing framework to use (spec, test_unit)'
    option :orm, :desc => 'Specify which Object-Relation Mapper to use (none, activerecord, datamapper, sequel)'
    
    first_argument :name, :required => true
    second_argument :attributes, :as => :hash, :default => {}
    
    invoke :migration do |generator|
      generator.new(destination_root, options.merge(:model => true), name, attributes)
    end
    
    [:none, :activerecord, :sequel, :datamapper].each do |orm|
    
      template "model_#{orm}".to_sym, :orm => orm do
        source("#{orm}/app/models/%file_name%.rb")
        destination("app/models/#{file_name}.rb")
      end
    
    end
    
    template :spec, :testing_framework => :rspec do
      source('rspec/spec/models/%file_name%_spec.rb')
      destination('spec/models/' + file_name + '_spec.rb')
    end
    
    template :test_unit, :testing_framework => :test_unit do
      source('test_unit/test/models/%file_name%_test.rb')
      destination('test/models/' + file_name + '_test.rb')
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
    
    def attributes?
      self.attributes && !self.attributes.empty?
    end
    
    def attributes_for_accessor
      self.attributes.keys.map{|a| ":#{a}" }.compact.uniq.join(", ")
    end
    
  end
  
  add :model, ModelGenerator
  
end