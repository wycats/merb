module Merb
  module Generators
    class MerbStackGenerator < AppGenerator
      #
      # ==== Paths
      #

      def self.source_root
        File.join(super, 'application', 'merb_stack')
      end

      def self.common_templates_dir
        File.expand_path(File.join(File.dirname(__FILE__), '..',
                                   'templates', 'application', 'common'))
      end

      def destination_root
        File.join(@destination_root, base_name)
      end

      def common_templates_dir
        self.class.common_templates_dir
      end

      #
      # ==== Generator options
      #

      option :testing_framework, :default => :rspec,
      :desc => 'Testing framework to use (one of: rspec, test_unit).'
      option :orm, :default => :none,
      :desc => 'Object-Relation Mapper to use (one of: none, activerecord, datamapper, sequel).'
      option :template_engine, :default => :erb,
      :desc => 'Template engine to prefer for this application (one of: erb, haml).'

      desc <<-DESC
      This generates a "jump start" Merb application with support for DataMapper,
      helpers, assets, mailer, caching, slices and merb-auth all out of the box.
    DESC

      first_argument :name, :required => true, :desc => "Application name"

      #
      # ==== Common directories & files
      #

      empty_directory :gems, 'gems'
      file :thorfile do |file|
        file.source      = File.join(common_templates_dir, "merb.thor")
        file.destination = "merb.thor"
      end

      template :rakefile do |template|
        template.source = File.join(common_templates_dir, "Rakefile")
        template.destination = "Rakefile"
      end

      file :gitignore do |file|
        file.source = File.join(common_templates_dir, 'dotgitignore')
        file.destination = ".gitignore"
      end

      file :htaccess do |file|
        file.source = File.join(common_templates_dir, 'dothtaccess')
        file.destination = 'public/.htaccess'
      end
      
      file :jquery do |file|
        file.source = File.join(common_templates_dir, 'jquery.js')
        file.destination = 'public/javascripts/jquery.js'
      end

      directory :test_dir do |directory|
        dir    = testing_framework == :rspec ? "spec" : "test"

        directory.source      = File.join(source_root, dir)
        directory.destination = dir
      end

      #
      # ==== Layout specific things
      #

      # empty array means all files are considered to be just
      # files, not templates
      glob! "app"
      glob! "autotest"
      glob! "config"
      glob! "doc",      []
      glob! "public"
      glob! "lib"

      invoke :layout do |generator|
        generator.new(destination_root, options, 'application')
      end
    end

    add :app,   MerbStackGenerator
  end
end
