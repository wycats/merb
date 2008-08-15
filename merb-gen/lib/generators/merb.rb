module Merb::Generators
  
  class MerbGenerator < Generator

    option :testing_framework, :default => :rspec, :desc => 'Testing framework to use (one of: rspec, test_unit)'
    option :orm, :default => :none, :desc => 'Object-Relation Mapper to use (one of: none, activerecord, datamapper, sequel)'
    option :flat, :as => :boolean, :desc => "Generate a flat application: one file + configs + templates directory."
    option :very_flat, :as => :boolean, :desc => "Generate a very flat, Sinatra-like one file application."
    
    desc <<-DESC
      Generates a merb application.
    DESC
    
    first_argument :name, :required => true, :desc => "Application name"
    
    invoke :app_full, :flat => nil, :very_flat => nil
    invoke :app_flat, :flat => true
    invoke :app_very_flat, :very_flat => true

  end
  
  add :app, MerbGenerator
  
end
