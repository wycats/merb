module Merb::Generators
  class PassengerGenerator < AppGenerator
    
    desc <<-DESC
      Generates the configuration files needed to run Merb with Phusion Passenger.
    DESC
    
    def self.source_root
      File.join(super, 'application', 'merb_stack')
    end

    file :config, "config.ru"
  end
  add :passenger, PassengerGenerator
end
