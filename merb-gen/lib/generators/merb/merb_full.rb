module Merb::Generators
  
  class MerbFullGenerator < NamedGenerator

    def self.source_root
      File.join(super, 'application', 'merb')
    end
    
    option :testing_framework, :default => :rspec, 
                               :desc => 'Testing framework to use (one of: rspec, test_unit).'                               
    option :orm, :default => :none, 
                 :desc => 'Object-Relation Mapper to use (one of: none, activerecord, datamapper, sequel).'
    option :template_engine, :default => :erb,
                :desc => 'Template engine to prefer for this application (one of: erb, haml).'
    
    desc <<-DESC
      This generates a Merb application with Ruby on Rails like structure.
      Generator lets you configure your ORM and testing framework of choice.
    DESC
    
    glob!
    
    first_argument :name, :required => true, :desc => "Application name"
    
    invoke :layout do |generator|
      generator.new(destination_root, options, 'application')
    end
    
    def destination_root
      File.join(@destination_root, base_name)
    end
    
  end
  
  add_private :app_full, MerbFullGenerator
  
end