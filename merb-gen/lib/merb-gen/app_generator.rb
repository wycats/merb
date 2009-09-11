module Merb
  module Generators

    class AppGenerator < NamedGenerator

      def initialize(*args)
        Merb.disable(:initfile)
        super
      end

      # Helper to get Merb version
      #
      # ==== Returns
      # String:: Merb version
      def merb_gems_version
        Merb::VERSION
      end

      def gems_for_orm(orm)
        orm.to_sym == :none ? '' : %Q{gem "merb_#{ orm }"}
      end

      def gems_for_template_engine(template_engine)
        if template_engine != :erb
          if template_engine.in?(:haml, :builder)
            template_engine_plugin = "merb-#{template_engine}"
          else
            template_engine_plugin = "merb_#{template_engine}"
          end
          %Q{gem "#{template_engine_plugin}"}
        end
      end

      def gems_for_testing_framework(test_framework)
        if test_framework == :test_unit 
          %Q{gem "#{test_framework}", :only => :test}
        elsif test_framework == :rspec
          %Q{gem "#{test_framework}", :require_as => "spec", :only => :test}
        end
      end

    end
  end
end
