# This is not intended to be modified.  It is for use with
# Authentication.default_customizations
class Merb::BootLoader::MerbAuthBootLoader < Merb::BootLoader
  before Merb::BootLoader::AfterAppLoads
  
  def self.run
    Authentication.default_customizations.each { |c| c.call }
  end
  
end