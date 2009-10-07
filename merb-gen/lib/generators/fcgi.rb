module Merb::Generators
  class FcgiGenerator < AppGenerator
    
    desc <<-DESC
      Generates the configuration files needed to run Merb with FastCGI.
    DESC
    
    def self.source_root
      File.join(super, 'component', 'fcgi')
    end
    
    file :dothtaccess, "dothtaccess", File.join("public", ".htaccess")
    file :merbfcgi, "merb.fcgi", File.join("public", "merb.fcgi")
  end
  add :fcgi, FcgiGenerator
end
