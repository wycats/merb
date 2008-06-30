module Merb::Generators
  
  class MerbFlatGenerator < ApplicationGenerator
    
    desc <<-DESC
      This generates a flat merb application
    DESC
    
    first_argument :name, :required => true
    
    template :init_rb, 'config/init.rb'
    
    file_list <<-LIST
      config/framework.rb
      views/foo.html.erb
      application.rb
      README.txt
    LIST

    def app_name
      self.name.snake_case
    end
    
    def destination_root
      File.join(@destination_root, app_name)
    end
    
    def self.source_root
      File.join(super, 'merb_flat')
    end
    
  end
  
  add :app_flat, MerbFlatGenerator
  
end