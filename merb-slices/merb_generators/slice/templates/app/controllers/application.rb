class <%= module_name %>::Application < Merb::Slices::Controller
  
  layout(Merb::Slices::config[:<%= underscored_name %>][:layout]) if Merb::Slices::config[:<%= underscored_name %>].key?(:layout)
  
end