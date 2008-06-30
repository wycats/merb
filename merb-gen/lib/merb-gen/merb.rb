module Merb::Generators
  
  class MerbGenerator < ApplicationGenerator

    def self.source_root
      File.join(super, 'merb')
    end
    
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
  
  add :app, MerbGenerator
  
end