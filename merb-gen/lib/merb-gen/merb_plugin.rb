module Merb::Generators
  
  class MerbPluginGenerator < ApplicationGenerator

    def self.source_root
      File.join(super, 'merb_plugin')
    end
    
    option :testing_framework, :default => :rspec, :desc => 'Specify which testing framework to use (spec, test_unit)'
    option :orm, :default => :none, :desc => 'Specify which Object-Relation Mapper to use (none, activerecord, datamapper, sequel)'
    option :bin, :as => :boolean # TODO: explain this
    
    desc <<-DESC
      This generates a plugin for merb
    DESC
    
    glob!
    
    first_argument :name, :required => true
    
    def base_name
      self.name.snake_case
    end
    
    def destination_root
      File.join(@destination_root, base_name)
    end
    
  end
  
  add :plugin, MerbPluginGenerator
  
end