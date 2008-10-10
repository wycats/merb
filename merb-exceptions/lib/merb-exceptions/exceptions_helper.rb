module MerbExceptions
  module ExceptionsHelper
    protected

    # renders unless Merb::Plugins.config[:exceptions][:environments]
    # includes the current environment, in which case it passes any
    # provided options directly to Merb's render method and then
    # sends the notification after rendering.
    def render_and_notify(*opts)
      if Merb::Plugins.config[:exceptions][:environments].include?(Merb.env)
        self.render_then_call(self.render(*opts)) { notify_of_exceptions }
      else
        self.render(*opts)
      end
    end

  end
end