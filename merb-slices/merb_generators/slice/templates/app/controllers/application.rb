class <%= module_name %>::Application < Merb::Controller
  
  controller_for_slice
  
  layout(Merb::Slices::config[:<%= underscored_name %>][:layout]) if Merb::Slices::config[:<%= underscored_name %>].key?(:layout)
  
end