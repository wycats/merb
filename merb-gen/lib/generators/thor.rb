module Merb
  module Generators
    class ThorGenerator < AppGenerator
      #
      # ==== Paths
      #

      def self.source_root
        File.join(super, 'application', 'common', 'merb_thor')
      end

      def destination_root
        File.join(@destination_root, 'tasks')
      end

      def common_templates_dir
        File.expand_path(File.join(File.dirname(__FILE__),
                                   'templates', 'application', 'common'))
      end

      directory :thor_file do |directory|
        directory.source = File.join(common_templates_dir, "merb_thor")
        directory.destination = File.join("merb.thor")
      end
    end
    add :thor,   ThorGenerator
  end
end
