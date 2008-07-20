module Merb::Generators
  
  class MerbFullGenerator < ApplicationGenerator

    def self.source_root
      File.join(super, 'merb')
    end
    
    option :testing_framework, :default => :rspec, :desc => 'Specify which testing framework to use (spec, test_unit)'
    option :orm, :default => :none, :desc => 'Specify which Object-Relation Mapper to use (none, activerecord, datamapper, sequel)'
    
    desc <<-DESC
      This generates a full merb application
    DESC
    
    glob!
    
    first_argument :name, :required => true
    
    def app_name
      self.name.snake_case
    end
    
    def destination_root
      File.join(@destination_root, app_name)
    end
    
  end
  
  add_private :app_full, MerbFullGenerator
  
end