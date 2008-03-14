if defined?(Merb::Plugins)
  Merb::Plugins.add_rakefiles "merb-cache/merbtasks"
  unless 1.respond_to? :minutes
    class Numeric #:nodoc:
      def minutes; self * 60; end
      def from_now(now = Time.now); now + self; end
    end
  end
  require "merb-cache/merb-cache"
end
