load File.dirname(__FILE__) / "form" / "helpers.rb"
load File.dirname(__FILE__) / "form" / "builder.rb"

class Merb::Controller
  class_inheritable_accessor :_default_builder
  include Merb::Helpers::Form
end

class Merb::PartController < Merb::AbstractController
  class_inheritable_accessor :_default_builder
  include Merb::Helpers::Form
end

Merb::BootLoader.after_app_loads do
  class Merb::Controller
    self._default_builder =
      Object.full_const_get(Merb::Plugins.config[:helpers][:default_builder]) rescue Merb::Helpers::Form::Builder::ResourcefulFormWithErrors
  end
  
  class Merb::PartController
    self._default_builder =
      Object.full_const_get(Merb::Plugins.config[:helpers][:default_builder]) rescue Merb::Helpers::Form::Builder::ResourcefulFormWithErrors
  end
end
