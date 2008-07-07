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
    
    def self.source_root
      File.join(super, 'none')
    end

    first_argument :name, :required => true
    second_argument :attributes, :as => :hash, :default => {}
    
    glob!
    
  end
  
  class ActiveRecordModelGenerator < ModelGenerator
    
    def self.source_root
      File.join(super, 'activerecord')
    end

    first_argument :name, :required => true
    second_argument :attributes, :as => :hash, :default => {}
    
    glob!
    
  end
  
  class DataMapperModelGenerator < ModelGenerator
    
    def self.source_root
      File.join(super, 'datamapper')
    end

    first_argument :name, :required => true
    second_argument :attributes, :as => :hash, :default => {}
    
    glob!
    
  end
  
  class SequelModelGenerator < ModelGenerator
    
    def self.source_root
      File.join(super, 'sequel')
    end

    first_argument :name, :required => true
    second_argument :attributes, :as => :hash, :default => {}
    
    glob!
    
  end
  
  class SpecModelGenerator < ModelGenerator
    
    def self.source_root
      File.join(super, 'rspec')
    end

    first_argument :name, :required => true
    second_argument :attributes, :as => :hash, :default => {}
    
    glob!
    
  end
  
  class TestUnitModelGenerator < ModelGenerator
    
    def self.source_root
      File.join(super, 'test_unit')
    end

    first_argument :name, :required => true
    second_argument :attributes, :as => :hash, :default => {}
    
    glob!
    
  end
  
  add :model, ModelGenerator
  add_private :model_none, NoneModelGenerator
  add_private :model_datamapper, DataMapperModelGenerator
  add_private :model_activerecord, ActiveRecordModelGenerator
  add_private :model_sequel, SequelModelGenerator
  add_private :model_test_unit, TestUnitModelGenerator
  add_private :model_rspec, SpecModelGenerator
  
end