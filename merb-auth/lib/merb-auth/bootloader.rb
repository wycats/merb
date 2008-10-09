class Merb::BootLoader::MerbAuthBootLoader < Merb::BootLoader
  before AfterAppLoads
  
  def self.run
    Authentication.default_customizations.each { |c| c.call }
  end
  
end