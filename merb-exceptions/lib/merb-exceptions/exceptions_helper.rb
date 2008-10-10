module MerbExceptions
  module ExceptionsHelper
    protected
    # This will always render, but will also send a notification if
    # Merb::Plugins.config[:exceptions][:environments] includes the
    # current environment.
    def self.included(mod)
      if Merb::Plugins.config[:exceptions][:environments].include?(Merb.env)
        mod.class_eval do
          def render_and_notify(*opts)
            self.render_then_call(render(*opts)) { notify_of_exceptions }
          end
        end
      else
        mod.class_eval do
          def render_and_notify(*opts)
            self.render(*opts)
          end
        end
      end
    end
  end
end