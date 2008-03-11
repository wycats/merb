Merb.logger.info("Loaded TEST Environment...")
Merb::Config.use { |c|
  c[:exception_details] = true
  c[:reload_classes] = false
}