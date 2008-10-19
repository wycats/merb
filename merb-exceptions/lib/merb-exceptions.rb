# make sure we're running inside Merb
if defined?(Merb::Plugins)

  # Default configuration
  Merb::Plugins.config[:exceptions] = {
    :web_hooks       => [],
    :email_addresses => [],
    :app_name        => "Merb awesome Application",
    :email_from      => "exceptions@app.com",
    :environments    => ['production']
  }.merge(Merb::Plugins.config[:exceptions] || {})

  Merb::BootLoader.before_app_loads do

  end

  Merb::BootLoader.after_app_loads do
    if Object.const_defined?(:Exceptions)
      Exceptions.send(:include, MerbExceptions::ExceptionsHelper)
    end
    if Merb::Plugins.config[:exceptions][:environments].include?(Merb.env)
      Merb::Dispatcher::DefaultException.send(:include, MerbExceptions::ExceptionsHelper)
      Merb::Dispatcher::DefaultException.send(:include, MerbExceptions::DefaultExceptionExtensions)
    end
  end

  require 'merb-exceptions/notification'
  require 'merb-exceptions/default_exception_extensions'
  require 'merb-exceptions/exceptions_helper'
end
