module Merb
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
end

require 'active_support'
require 'rubigen/base'
require 'rubigen/commands'
module RubiGen
  module Commands
    class RewindBase < Base
  
      def file_copy_each(files, path=nil, options = {})
        path = path ? "#{path}/" : ""
        files.each do |file_name|
          file "#{path}#{file_name}", "#{path}#{file_name}", options
        end
      end
      
    end
  end
end