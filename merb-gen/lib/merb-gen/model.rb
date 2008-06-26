module Merb::Generators
  
  class ModelGenerator < ComponentGenerator
    
    desc <<-DESC
      This is a model generator
    DESC
    
    option :testing_framework, :desc => 'Specify which testing framework to use (spec, test_unit)'
    option :orm, :desc => 'Specify which Object-Relation Mapper to use (none, activerecord, datamapper, sequel)'
    
    first_argument :name, :required => true
    second_argument :attributes, :as => :hash, :default => {}
    
    # TODO: this is how the syntax for invoking other generators *should* look like, refactor in templater!
    #invoke :migration do |generator|
    #  generator.new(destination_root, options.merge(:model => true), *arguments)
    #end
    
    template :model, :orm => :none do
      source('model.rbt')
      destination('app/models/' + file_name + '.rb')
    end
    
    template :model_activerecord, :orm => :activerecord do
      source('model_activerecord.rbt')
      destination('app/models/' + file_name + '.rb')
    end
    
    template :model_datamapper, :orm => :datamapper do
      source('model_datamapper.rbt')
      destination('app/models/' + file_name + '.rb')
    end
    
    template :model_sequel, :orm => :sequel do
      source('model_sequel.rbt')
      destination('app/models/' + file_name + '.rb')
    end
    
    template :spec, :testing_framework => :rspec do
      source('spec.rbt')
      destination('spec/models/' + file_name + '_spec.rb')
    end
    
    template :test_unit, :testing_framework => :test_unit do
      source('test_unit.rbt')
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
    
    def source_root
      File.join(super, 'model')
    end
    
  end
  
  add :model, ModelGenerator
  
end