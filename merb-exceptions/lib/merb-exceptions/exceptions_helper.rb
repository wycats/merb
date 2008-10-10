module MerbExceptions
  module ExceptionsHelper
    protected
    # This will always render, but will also send a notification if
    # Merb::Plugins.config[:exceptions][:environments] includes the
    # current environment.
    def render_and_notify(*opts)
      if Merb::Plugins.config[:exceptions][:environments].include?(Merb.env)
        self.render_then_call(render(*opts)) { notify_of_exceptions }
      else
        self.render(*opts)
      end
    end
  end
end