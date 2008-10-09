module Merb
  module Generators

    class AppGenerator < NamedGenerator

      def initialize(*args)
        Merb.disable(:initfile)
        super(*args)
      end

    end
  end
end
