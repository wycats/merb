module Merb::Generators
  
  class PartControllerGenerator < ChunkyGenerator

    def self.source_root
      File.join(super, 'part_controller')
    end
    
    desc <<-DESC
      This is a part controller generator
    DESC
    
    first_argument :name, :required => true
    
    invoke :helper do |generator|
      generator.new(destination_root, options, "#{full_class_name}Part")
    end
    
    template :controller do
      source('app/parts/%file_name%_part.rb')
      destination("app/parts/#{file_name}_part.rb")
    end
    
    template :index do
      source('app/parts/views/%file_name%_part/index.html.erb')
      destination("app/parts/views/#{file_name}_part/index.html.erb")
    end
    
  end
  
  add :part, PartControllerGenerator
  
end