# dependencies are generated using a strict version, don't forget to edit the dependency versions when upgrading.

# For more information about each component, please read http://wiki.merbivore.com/faqs/merb_components
# dependency "merb-action-args", merb_gems_version
# dependency "merb-assets", merb_gems_version  
# dependency "merb-cache", merb_gems_version   
Merb::BootLoader.before_app_loads do
  require Merb.framework_root / ".." / ".." / "merb-helpers" / "lib" / "merb-helpers.rb"
end
# dependency "merb-mailer", merb_gems_version  
# dependency "merb-slices", merb_gems_version  
# dependency "merb-auth-core", merb_gems_version
# dependency "merb-auth-more", merb_gems_version
# dependency "merb-auth-slice-password", merb_gems_version
# dependency "merb-param-protection", merb_gems_version
# dependency "merb-exceptions", merb_gems_version
 
# dependency "dm-core", dm_gems_version         
# dependency "dm-aggregates", dm_gems_version   
# dependency "dm-migrations", dm_gems_version   
# dependency "dm-timestamps", dm_gems_version   
# dependency "dm-types", dm_gems_version        
# dependency "dm-validations", dm_gems_version  
