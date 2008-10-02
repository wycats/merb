module Merb::Generators
  
  class MerbVeryFlatGenerator < NamedGenerator

    def self.source_root
      File.join(super, 'application', 'merb_very_flat')
    end

    option :testing_framework, :default => :rspec,
                               :desc => 'Testing framework to use (one of: rspec, test_unit).'
    option :orm, :default => :none,
                 :desc => 'Object-Relation Mapper to use (one of: none, activerecord, datamapper, sequel).'
    option :template_engine, :default => :erb,
                :desc => 'Template engine to prefer for this application (one of: erb, haml).'
    
    
    desc <<-DESC
      This generates a very flat merb application: the whole application
      fits in one file, very much like Sinatra or Camping.
    DESC
    
    first_argument :name, :required => true, :desc => "Application name"
    
    template :application do |template|
      template.source = 'application.rbt'
      template.destination = "#{base_name}.rb"
    end

    template :gitignore do |template|
      template.source = File.join(common_templates_dir, 'dotgitignore')
      template.destination = ".gitignore"
    end

    directory :test_dir do |directory|
      test_dir    = testing_framework == :rspec ? "spec" : "test"
      
      directory.source      = File.join(source_root, test_dir)
      directory.destination = test_dir
    end    
    
    def class_name
      self.name.camel_case
    end

    def common_templates_dir
      File.expand_path(File.join(File.dirname(__FILE__), '..',
                      'templates', 'application', 'common'))
    end
  end
  
  add_private :app_very_flat, MerbVeryFlatGenerator
end
