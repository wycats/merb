module Merb::Generators
  
  class FreezerGenerator < ComponentGenerator

    def self.source_root
      File.join(super, 'freezer')
    end
    
    desc <<-DESC
      Generates a freezer
    DESC
    
    template :freezer, 'script/frozen_merb', 'script/frozen_merb'
    
  end
  
  add :freezer, FreezerGenerator
  
end