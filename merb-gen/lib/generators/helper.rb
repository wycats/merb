module Merb::Generators
  
  class HelperGenerator < NamespacedGenerator

    def self.source_root
      File.join(super, 'component', 'helper')
    end
    
    desc <<-DESC
      Generates a new helper.
    DESC
    
    option :testing_framework, :desc => 'Testing framework to use (one of: rspec, test_unit)'
    
    first_argument :name, :required => true, :desc => "helper name"
    
    template :helper do |template|
      template.source = 'app/helpers/%file_name%_helper.rb'
      template.destination = "app/helpers" / base_path / "#{file_name}_helper.rb"
    end
    
    template :helper_spec, :testing_framework => :rspec do |template|
      template.source = 'spec/helpers/%file_name%_helper_spec.rb'
      template.destination = "spec/helpers" / base_path / "#{file_name}_helper_spec.rb"
    end
    
  end
  
  add :helper, HelperGenerator
  
end
