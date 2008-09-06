module Merb::Generators
  
  class MerbVeryFlatGenerator < NamedGenerator

    def self.source_root
      File.join(super, 'application', 'merb_very_flat')
    end
    
    desc <<-DESC
      This generates a very flat merb application: the whole application
      fits in one file, very much like Sinatra or Camping.
    DESC
    
    first_argument :name, :required => true, :desc => "Application name"
    
    template :application do |template|
      template.source = 'application.rbt'
      template.destination = "#{base_name}.rb"
    end

    file :spec_helper, 'spec/spec_helper.rb', 'spec/spec_helper.rb'
    
    def class_name
      self.name.camel_case
    end
    
  end
  
  add_private :app_very_flat, MerbVeryFlatGenerator
  
end
