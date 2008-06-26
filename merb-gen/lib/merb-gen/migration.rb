module Merb::Generators
  
  class MigrationGenerator < ComponentGenerator
    
    desc <<-DESC
      This is a migration generator
    DESC
    
    option :orm, :default => :none, :desc => 'Specify which Object-Relation Mapper to use (none, activerecord, datamapper, sequel)'
    option :model, :as => :boolean, :desc => 'Set this option to generate a migration which creates a table for the provided model'
    
    first_argument :name, :required => true
    second_argument :attributes, :as => :hash, :default => {}
    
    template :migration_activerecord, :orm => :activerecord do
      source('migration_activerecord.rbt')
      destination("schema/migrations/#{version}_#{file_name}.rb")
    end
    
    template :migration_datamapper, :orm => :datamapper do
      source('migration_datamapper.rbt')
      destination("schema/migrations/#{version}_#{file_name}.rb")
    end
    
    template :migration_sequel, :orm => :sequel do
      source('migration_sequel.rbt')
      destination("schema/migrations/#{version}_#{file_name}.rb")
    end
    
    def table_name
      self.name.snake_case.pluralize
    end
    
    def class_name
      self.name.camel_case
    end
    
    def file_name
      self.name.snake_case
    end
    
    def source_root
      File.join(super, 'migration')
    end
    
    def version
      # TODO: handle ActiveRecord timestamped migrations
      format("%03d", current_migration_nr + 1)
    end

    protected
    
    def destination_directory
      File.join(destination_root, 'schema', 'migrations')
    end
    
    def current_migration_nr
      current_migration_number = Dir["#{destination_directory}/*"].map{|f| File.basename(f).match(/^(\d+)/)[0].to_i  }.max.to_i
    end
    
  end
  
  add :migration, MigrationGenerator
  
end