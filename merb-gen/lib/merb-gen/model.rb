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
    
    invoke :model_none, :orm => :none
    invoke :model_activerecord, :orm => :activerecord
    invoke :model_datamapper, :orm => :datamapper
    invoke :model_sequel, :orm => :sequel
    
    invoke :model_rspec, :testing_framework => :rspec
    invoke :model_test_unit, :testing_framework => :test_unit
    
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
  
  class NoneModelGenerator < ModelGenerator
    
    first_argument :name, :required => true
    second_argument :attributes, :as => :hash, :default => {}
    
    def self.source_root
      File.join(super, 'none')
    end
    
    glob!
    
  end
  
  class ActiveRecordModelGenerator < ModelGenerator
    
    first_argument :name, :required => true
    second_argument :attributes, :as => :hash, :default => {}
    
    def self.source_root
      File.join(super, 'activerecord')
    end
    
    glob!
    
  end
  
  class DataMapperModelGenerator < ModelGenerator
    
    first_argument :name, :required => true
    second_argument :attributes, :as => :hash, :default => {}
    
    def self.source_root
      File.join(super, 'datamapper')
    end
    
    glob!
    
  end
  
  class SequelModelGenerator < ModelGenerator
    
    first_argument :name, :required => true
    second_argument :attributes, :as => :hash, :default => {}
    
    def self.source_root
      File.join(super, 'sequel')
    end
    
    glob!
    
  end
  
  class SpecModelGenerator < ModelGenerator
    
    first_argument :name, :required => true
    second_argument :attributes, :as => :hash, :default => {}
    
    def self.source_root
      File.join(super, 'rspec')
    end
    
    glob!
    
  end
  
  class TestUnitModelGenerator < ModelGenerator
    
    first_argument :name, :required => true
    second_argument :attributes, :as => :hash, :default => {}
    
    def self.source_root
      File.join(super, 'test_unit')
    end
    
    glob!
    
  end
  
  add :model, ModelGenerator
  add :model_none, NoneModelGenerator
  add :model_datamapper, DataMapperModelGenerator
  add :model_activerecord, ActiveRecordModelGenerator
  add :model_sequel, SequelModelGenerator
  add :model_test_unit, TestUnitModelGenerator
  add :model_rspec, SpecModelGenerator
  
end