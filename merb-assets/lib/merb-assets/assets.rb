module Merb
  module Assets
    
    # Check whether the assets should be bundled.
    #
    # ==== Returns
    # Boolean::
    #   True if the assets should be bundled (e.g., production mode or
    #   :bundle_assets is explicitly enabled).
    def self.bundle?
      (Merb.environment == 'production') ||
      (!!Merb::Config[:bundle_assets])
    end
    
    # Helpers for handling asset files.
    module AssetHelpers
      # :nodoc:
      ASSET_FILE_EXTENSIONS = {
        :javascript => ".js",
        :stylesheet => ".css"
      }
      
      # Returns the URI path to a particular asset file. If +local_path+ is
      # true, returns the path relative to the Merb.root, not the public
      # directory. Uses the path_prefix, if any is configured.
      # 
      # ==== Parameters
      # asset_type<Symbol>:: Type of the asset (e.g. :javascript).
      # filename<~to_s>:: The path to the file.
      # local_path<Boolean>::
      #   If true, the returned path will be relative to the Merb.root,
      #   otherwise it will be the public URI path. Defaults to false.
      #
      # ==== Returns
      # String:: The path to the asset.
      #
      # ==== Examples
      #   asset_path(:javascript, :dingo)
      #   # => "/javascripts/dingo.js"
      #
      #   asset_path(:javascript, :dingo, true)
      #   # => "public/javascripts/dingo.js"
      def asset_path(asset_type, filename, local_path = false)
        filename = filename.to_s
        if filename !~ /#{'\\' + ASSET_FILE_EXTENSIONS[asset_type]}\Z/
          filename << ASSET_FILE_EXTENSIONS[asset_type]
        end
        filename = "/#{asset_type}s/#{filename}"
        if local_path
          return "public#{filename}"
        else
          return "#{Merb::Config[:path_prefix]}#{filename}"
        end
      end
    end
    
    # Helper for creating unique paths to a file name
    # Can increase speend for browsers that are limited to a certain number of connections per host 
    # for downloading static files (css, js, images...)
    class UniqueAssetPath
      class << self
        @@config = Merb::Plugins.config[:asset_helpers]
        
        # Builds the path to the file based on the name
        # 
        # ==== Parameters
        # filename<String>:: Name of file to generate path for
        #
        # ==== Returns
        # String:: The path to the asset.
        #
        # ==== Examples
        #   build("/javascripts/my_fancy_script.js")
        #   # => "https://assets5.my-awesome-domain.com/javascripts/my_fancy_script.js"
        #
        def build(filename)
          #%{#{(USE_SSL ? 'https' : 'http')}://#{sprintf(@@config[:asset_domain],self.calculate_host_id(file))}.#{@@config[:domain]}/#{filename}}
          path = @@config[:use_ssl] ? 'https://' : 'http://'
          path << sprintf(@@config[:asset_domain],self.calculate_host_id(filename)) << ".#{@@config[:domain]}"
          path << "/" if filename.index('/') != 0
          path << filename
        end
      
        protected
        
        # Calculates the id for the host
        def calculate_host_id(filename)
          ascii_total = 0
          filename.each_byte {|byte|
            ascii_total += byte
          }
          (ascii_total % @@config[:max_hosts] + 1)
        end
      end
    end
    
    # An abstract class for bundling text assets into single files.
    class AbstractAssetBundler
      class << self
        
        # ==== Parameters
        # &block:: A block to add as a post-bundle callback.
        #
        # ==== Examples
        #   add_callback { |filename| `yuicompressor #{filename}` }
        def add_callback(&block)
          callbacks << block
        end
        alias_method :after_bundling, :add_callback
        
        # Retrieve existing callbacks.
        #
        # ==== Returns
        # Array[Proc]:: An array of existing callbacks.
        def callbacks
          @callbacks ||= []
          return @callbacks
        end
        
        # The type of asset for which the bundler is responsible. Override
        # this method in your bundler code.
        #
        # ==== Raises
        # NotImplementedError:: This method is implemented by the bundler.
        #
        # ==== Returns
        # Symbol:: The type of the asset
        def asset_type
          raise NotImplementedError, "should return a symbol for the first argument to be passed to asset_path"
        end
      end

      # ==== Parameters
      # name<~to_s>::
      #   Name of the bundle. If name is true, it will be converted to :all.
      # *files<String>:: Names of the files to bundle.
      def initialize(name, *files)
        @bundle_name = name == true ? :all : name
        @bundle_filename = asset_path(self.class.asset_type, @bundle_name, true)
        @files = files.map { |f| asset_path(self.class.asset_type, f, true) }
      end
      
      # Creates the new bundled file, executing all the callbacks.
      #
      # ==== Returns
      # Symbol:: Name of the bundle.
      def bundle!
        # TODO: Move this file check out into an in-memory cache. Also, push it out to the helper level so we don't have to create the helper object.
        unless File.exist?(@bundle_filename)
          bundle_files(@bundle_filename, *@files)
          self.class.callbacks.each { |c| c.call(@bundle_filename) }
        end
        return @bundle_name
      end
      
    protected
      
      include Merb::Assets::AssetHelpers # for asset_path
      
      # Bundle all the files into one.
      #
      # ==== Parameters
      # filename<String>:: Name of the bundle file.
      # *files<String>:: Filenames to be bundled.
      def bundle_files(filename, *files)
        File.open(filename, "w") do |f|
          files.each { |file| f.puts(File.read(file)) }
        end
      end
      
    end
    
    # Bundles javascripts into a single file:
    # 
    #   javascripts/#{name}.js
    class JavascriptAssetBundler < AbstractAssetBundler

      # ==== Returns
      # Symbol:: The asset type, i.e. :javascript.
      def self.asset_type
        :javascript
      end
    end
    
    # Bundles stylesheets into a single file:
    # 
    #   stylesheets/#{name}.css
    class StylesheetAssetBundler < AbstractAssetBundler

      # ==== Returns
      # Symbol:: The asset type, i.e. :stylesheet.
      def self.asset_type
        :stylesheet
      end
    end
    
  end
end