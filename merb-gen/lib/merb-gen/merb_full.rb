module Merb::Generators
  
  class MerbFullGenerator < ApplicationGenerator

    def self.source_root
      File.join(super, 'merb')
    end
    
    option :testing_framework, :default => :rspec, 
                               :desc => 'Testing framework to use (one of: spec, test_unit).'                               
    option :orm, :default => :none, 
                 :desc => 'Object-Relation Mapper to use (one of: none, activerecord, datamapper, sequel).'
    
    desc <<-DESC
      This generates a Merb application with Ruby on Rails like structure.
      Generator lets you configure your ORM and testing framework of choice.
    DESC
    
    glob!
    
    first_argument :name, :required => true, :desc => "Application name"
    
    def app_name
      self.name.snake_case
    end
    
    def destination_root
      File.join(@destination_root, app_name)
    end
    
  end
  
  add_private :app_full, MerbFullGenerator
  
end