module Merb::Generators
  
  class MerbVeryFlatGenerator < ApplicationGenerator

    def self.source_root
      File.join(super, 'merb_very_flat')
    end
    
    desc <<-DESC
      This generates a very flat merb application
    DESC
    
    first_argument :name, :required => true
    
    template :application do
      source('application.rbt')
      destination("#{app_name}.rb")
    end
    
    def app_name
      self.name.snake_case
    end
    
    def class_name
      self.name.camel_case
    end
    
  end
  
  add :app_very_flat, MerbVeryFlatGenerator
  
end