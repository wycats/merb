module Merb::Generators
  
  class MerbFlatGenerator < NamedGenerator
    
    def self.source_root
      File.join(super, 'application', 'merb_flat')
    end

    option :testing_framework, :default => :rspec,
                               :desc => 'Testing framework to use (one of: rspec, test_unit).'
    option :orm, :default => :none,
                 :desc => 'Object-Relation Mapper to use (one of: none, activerecord, datamapper, sequel).'
    option :template_engine, :default => :erb,
                :desc => 'Template engine to prefer for this application (one of: erb, haml).'
    
    desc <<-DESC
      This generates a flat merb application: all code but config files and
      templates fits in one application. This is something in between Sinatra
      and "regular" Merb application.
    DESC
    
    first_argument :name, :required => true, :desc => "Application name"

    template :gitignore do |template|
      template.source = File.join(common_templates_dir, 'dotgitignore')
      template.destination = ".gitignore"
    end

    directory :test_dir do |directory|
      test_dir    = testing_framework == :rspec ? "spec" : "test"
      
      directory.source      = File.join(source_root, test_dir)
      directory.destination = test_dir
    end    

    file     :readme,      "README.txt"
    file     :rakefile,    "Rakefile"    
    template :application, "application.rb"
    
    glob! "config"
    glob! "views"

    empty_directory :gems, 'gems'

    def class_name
      self.name.camel_case
    end
    
    def destination_root
      File.join(@destination_root, base_name)
    end

    def common_templates_dir
      File.expand_path(File.join(File.dirname(__FILE__), '..',
                      'templates', 'application', 'common'))
    end
  end
  
  add_private :app_flat, MerbFlatGenerator
  
end
