require 'rubigen'
module Merb
  require File.join(File.dirname(__FILE__), "merb-gen", "base")
  
  class ApplicationGenerator
    def self.run(path, argv, generator, command)
      if command == "destroy"
        puts "destroying app"
        FileUtils.rm_rf(File.expand_path(path))
        puts "done"
        exit
      end
      
      source = RubiGen::PathSource.new(:application, 
        File.join(File.dirname(__FILE__), "..", "app_generators"))
      RubiGen::Base.reset_sources
      RubiGen::Base.append_sources source
      puts RubiGen::Scripts.const_get(command.capitalize).inspect
      RubiGen::Scripts.const_get(command.capitalize).new.run([File.expand_path(path), *argv], :generator => generator, :backtrace => true)
    end
  end
  
  class ComponentGenerator
    def self.run(name, argv, generator, command)
      app_root = Dir.pwd
      
      # Merb.start :environment => 'development'
      
      Gem.clear_paths
      Gem.path.unshift(app_root / "gems")
      
      require "rubigen/scripts/#{command}"
      
      RubiGen::Base.use_component_sources! Merb.generator_scope
      RubiGen::Scripts.const_get(command.capitalize).new.run(argv, :generator => generator, :destination => app_root)
    end
  end
end