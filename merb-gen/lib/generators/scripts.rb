module Merb::Generators
  
  class ScriptsGenerator < Generator

    def self.source_root
      File.join(super, 'component', 'scripts')
    end
    
    desc <<-DESC
      Generates local Merb scripts (script/merb and script/merb-gen for example).
    DESC
    
    # Install a script/merb script for local execution (for frozen apps).
    file :script_merb do |f|
      f.source = bin_merb_location
      f.destination = 'script/merb'
    end
    
    # Install a script/merb-gen script for local execution (for frozen apps).
    file :script_merb_gen do |f|
      f.source = bin_merb_gen_location
      f.destination = 'script/merb-gen'
    end
     
    protected
    
    def bin_merb_location
      if (gem_spec = Gem.source_index.search('merb-core').last) && 
        File.exists?(location = File.join(gem_spec.full_gem_path, gem_spec.bindir, 'merb'))
        location
      else
        'script/merb'
      end
    end
    
    def bin_merb_gen_location
      if (gem_spec = Gem.source_index.search('merb-gen').last) && 
        File.exists?(location = File.join(gem_spec.full_gem_path, gem_spec.bindir, 'merb-gen'))
        location
      else
        'script/merb-gen'
      end
    end
    
  end
  
  add :scripts, ScriptsGenerator
  
  puts ScriptsGenerator
  
end
