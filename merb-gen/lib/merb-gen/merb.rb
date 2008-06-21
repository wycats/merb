require 'sha1'

module Merb::Generators
  
  class MerbGenerator < ApplicationGenerator
    
    desc <<-DESC
      This generates a full merb application
    DESC
    
    option :testing_framework, :default => :spec, :desc => 'Specify which testing framework to use (spec, test_unit)'
    option :orm, :default => :none, :desc => 'Specify which Object-Relation Mapper to use (none, activerecord, datamapper, sequel)'
    
    first_argument :name, :required => true
    
    template :init_rb, 'config/init.rb'
    
    file_list <<-LIST
      app/controllers/application.rb
      app/controllers/exceptions.rb
      app/helpers/global_helpers.rb
      app/views/exceptions/internal_server_error.html.erb
      app/views/exceptions/not_acceptable.html.erb
      app/views/exceptions/not_found.html.erb
      app/views/layout/application.html.erb
      autotest/discover.rb
      autotest/merb.rb
      autotest/merb_rspec.rb
      config/environments/development.rb
      config/environments/production.rb
      config/environments/rake.rb
      config/environments/test.rb
      config/rack.rb
      config/router.rb
      public/images/merb.jpg
      public/stylesheets/master.css
      public/merb.fcgi
      Rakefile
    LIST

    file :spec, 'spec/spec_helper.rb', :testing_framework => :spec
    file :spec_opts, 'spec/spec.opts', :testing_framework => :spec
    file :test, 'test/test_helper.rb', :testing_framework => :test_unit
    file :htaccess, 'public/htaccess', 'public/.htaccess'
    
    def app_name
      self.name.snake_case
    end
    
    def destination_root
      File.join(@destination_root, app_name)
    end
    
    def source_root
      File.join(super, 'merb')
    end
    
  end
  
  add :app, MerbGenerator
  
end