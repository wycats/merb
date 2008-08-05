module Merb::Generators
  
  class SessionMigrationGenerator < ComponentGenerator

    def self.source_root
      File.join(super, 'session_migration')
    end
    
    desc <<-DESC
      Generates a new session migration.
    DESC
    
    option :orm, :desc => 'Object-Relation Mapper to use (one of: none, activerecord, datamapper, sequel)'
    
    template :session_migration_activerecord, :orm => :activerecord do
      source('activerecord/schema/migrations/%version%_sessions.rb')
      destination("schema/migrations/#{version}_sessions.rb")
    end
    
    template :session_migration_sequel, :orm => :sequel do
      source('sequel/schema/migrations/%version%_sessions.rb')
      destination("schema/migrations/#{version}_sessions.rb")
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
  
  add :session_migration, SessionMigrationGenerator
  
end