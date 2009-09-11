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

      # ORM gem dependencies
      #
      # Adds ORM plugin dependency 'merb_#{orm}' if we use any ORM.
      #
      # ==== Params
      # orm<Symbol>:: ORM to use 
      #
      # ==== Returns
      # String:: Gem dependencies
      def gems_for_orm(orm)
        orm.to_sym == :none ? '' : %Q{gem "merb_#{orm}"}
      end

      # Template enging gem dependencies
      #
      # When using something else than erb we add merb plugin 
      # dependency for the template engine.
      #
      # ==== Params
      # template_engine<Symbol>:: Template engine to use 
      #
      # ==== Returns
      # String:: Gem dependencies
      def gems_for_template_engine(template_engine)
        gems = ''
        if template_engine != :erb
          if template_engine.in?(:haml, :builder)
            template_engine_plugin = "merb-#{template_engine}"
          else
            template_engine_plugin = "merb_#{template_engine}"
          end
          gems = %Q{gem "#{template_engine_plugin}"}
        end
        gems
      end

      # Testing framework gem dependencies
      #
      # If we use any other test framework than RSpec we must add dependency 
      # to the Gemfile. Merb depends on the RSpec so it's default dependency.
      #
      # ==== Params
      # test_framework<Symbol>:: Testing framework to use 
      #
      # ==== Returns
      # String:: Gem dependencies
      def gems_for_testing_framework(testing_framework)
        testing_framework == :rspec ? '' : %Q{gem "#{testing_framework}", :only => :test}  
      end

    end
  end
end
