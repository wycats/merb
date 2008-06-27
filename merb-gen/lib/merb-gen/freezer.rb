module Merb::Generators
  
  class FreezerGenerator < ComponentGenerator
    
    desc <<-DESC
      Generates a freezer
    DESC
    
    file :freezer, 'frozen_merb', 'script/frozen_merb'
    
    def source_root
      File.join(super, 'freezer')
    end
    
  end
  
  add :freezer, FreezerGenerator
  
end