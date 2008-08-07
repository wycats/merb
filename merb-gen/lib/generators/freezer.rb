module Merb::Generators
  
  class FreezerGenerator < Generator

    def self.source_root
      File.join(super, 'component', 'freezer')
    end
    
    desc <<-DESC
      Generates Merb freezer scripts.
    DESC
    
    template :freezer, 'script/frozen_merb', 'script/frozen_merb'
    
  end
  
  add :freezer, FreezerGenerator
  
end
