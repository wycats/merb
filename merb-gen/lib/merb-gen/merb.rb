module Merb::Generators
  
  class MerbGenerator < ApplicationGenerator

    def self.source_root
      File.join(super, 'merb')
    end
    
    option :testing_framework, :default => :rspec, :desc => 'Specify which testing framework to use (spec, test_unit)'
    option :orm, :default => :none, :desc => 'Specify which Object-Relation Mapper to use (none, activerecord, datamapper, sequel)'
    option :flat, :as => :boolean, :desc => 'Generates a flattened application'
    option :very_flat, :as => :boolean, :desc => 'Generates a single file application'
    
    desc <<-DESC
      Generates a merb application.
    DESC
    
    first_argument :name, :required => true
    
    invoke :app_full, :flat => nil, :very_flat => nil
    invoke :app_flat, :flat => true
    invoke :app_very_flat, :very_flat => true
  end
  
  add :app, MerbGenerator
  
end