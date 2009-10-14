# Kernel Mixin for Dependency Management
#
# ==== Deprecated (1.1)
# this module is to maintain compatibility with
# 1.x specs and will be removed in Merb 2.0
# 
# Kernel.dependency and Kernel.dependencies will go away
# in Merb 2.0. Please do not use it.
# 
# The prefered approach is to use the Bundler gemfile
# in order load your gems.
module Kernel
  # Keep track of all required dependencies. 
  #
  # @param name<String> The name of the gem to load.
  # @param *ver<Gem::Requirement, Gem::Version, Array, #to_str>
  #   Version requirements to be passed to Gem::Dependency.new.
  #
  # @return <Gem::Dependency> Dependency information
  #
  # :api: private
  def track_dependency(name, clr, *ver, &blk)
    options = ver.last.is_a?(Hash) ? ver.pop : {}
    new_dep = Gem::Dependency.new(name, ver.empty? ? nil : ver)
    new_dep.require_block = blk
    new_dep.require_as = options.key?(:require_as) ? options[:require_as] : name
    new_dep.original_caller = clr
    new_dep.source = options[:source]
  
    deps = Merb::BootLoader::Dependencies.dependencies

    idx = deps.each_with_index {|d,i| break i if d.name == new_dep.name}

    idx = idx.is_a?(Array) ? deps.size + 1 : idx
    deps.delete_at(idx)
    deps.insert(idx - 1, new_dep)

    new_dep
  end

  # Loads the given string as a gem. Execution is deferred until
  # after the logger has been instantiated and the framework directory
  # structure is defined.
  #
  # If that has already happened, the gem will be activated
  # immediately, but it will still be registered.
  # 
  # ==== Depecated (1.1) 
  # Dependency handling on the Framework level have been deprecated and
  # all the related API will be removed in the 2.0 release.
  #
  # Please use Bundler to manage your dependencies. Use tools provided
  # in RubyGems to define your dependencies in the Rakefiles or gemspecs
  # for your gems, plugins or slices.
  #
  # ==== Parameters
  # name<String> The name of the gem to load.
  # *ver<Gem::Requirement, Gem::Version, Array, #to_str>
  #   Version requirements to be passed to Gem::Dependency.new.
  #   If the last argument is a Hash, extract the :immediate option,
  #   forcing a dependency to load immediately.
  #
  # ==== Options
  #
  # :immediate   when true, gem is loaded immediately even if framework is not yet ready.
  # :require_as  file name to require for this gem.
  #
  # See examples below.
  #
  # ==== Notes
  #
  # If block is given, it is called after require is called. If you use a block to
  # require multiple files, require first using :require_as option and the rest
  # in the block.
  #
  # ==== Examples
  #
  # Usage scenario is typically one of the following:
  #
  # 1. Gem name and loaded file names are the same (ex.: amqp gem uses amqp.rb).
  #    In this case no extra options needed.
  #
  # dependency "amqp"
  #
  # 2. Gem name is different from the file needs to be required
  #    (ex.: ParseTree gem uses parse_tree.rb as main file).
  #
  # dependency "ParseTree", :require_as => "parse_tree"
  #
  # 3. You need to require a number of files from the library explicitly
  #    (ex.: cherry pick features from xmpp4r). Pass an array to :require_as.
  #
  # dependency "xmpp4r", :require_as => %w(xmpp4r/client xmpp4r/sasl xmpp4r/vcard)
  #
  # 4. You need to require a specific version of the gem.
  #
  # dependency "RedCloth", "3.0.4"
  #
  # 5. You want to load dependency as soon as the method is called.
  #
  # dependency "syslog", :immediate => true
  #
  # 6. You need to execute some arbitraty code after dependency is loaded:
  #
  # dependency "ruby-growl" do
  #   g = Growl.new "localhost", "ruby-growl",
  #              ["ruby-growl Notification"]
  #   g.notify "ruby-growl Notification", "Ruby-Growl is set up",
  #         "Ruby-Growl is set up"
  # end
  #
  # When specifying a gem version to use, you can use the same syntax RubyGems
  # support, for instance, >= 3.0.2 or >~ 1.2.
  #
  # See rubygems.org/read/chapter/16 for a complete reference.
  #
  # ==== Returns
  # Gem::Dependency:: The dependency information.
  #
  # :api: public
  # @deprecated
  def dependency(name, *opts, &blk)
    warn("DEPRECATED: Use bundler to setup and load dependency #{name}.")
    immediate = opts.last.delete(:immediate) if opts.last.is_a?(Hash)
    if immediate || Merb::BootLoader.finished?(Merb::BootLoader::Dependencies)
      load_dependency(name, caller, *opts, &blk)
    else
      track_dependency(name, caller, *opts, &blk)
    end
  end

  # Loads the given string as a gem.
  #
  # This new version tries to load the file via ROOT/gems first before moving
  # off to the system gems (so if you have a lower version of a gem in
  # ROOT/gems, it'll still get loaded).
  #
  # @param name<String,Gem::Dependency> 
  #   The name or dependency object of the gem to load.
  # @param *ver<Gem::Requirement, Gem::Version, Array, #to_str>
  #   Version requirements to be passed to Gem.activate.
  #
  # @note
  #   If the gem cannot be found, the method will attempt to require the string
  #   as a library.
  #
  # @return <Gem::Dependency> The dependency information.
  #
  # :api: private
  def load_dependency(name, clr, *ver, &blk)
    begin
      dep = name.is_a?(Gem::Dependency) ? name : track_dependency(name, clr, *ver, &blk)
      return unless dep.require_as
      Gem.activate(dep)
    rescue Gem::LoadError => e
      e.set_backtrace dep.original_caller
      Merb.fatal! "The gem #{name}, #{ver.inspect} was not found", e
    end

    begin
      require dep.require_as
    rescue LoadError => e
      e.set_backtrace dep.original_caller
      Merb.fatal! "The file #{dep.require_as} was not found", e
    end

    if block = dep.require_block
      # reset the require block so it doesn't get called a second time
      dep.require_block = nil
      block.call
    end

    Merb.logger.verbose!("loading gem '#{dep.name}' ...")
    return dep # ensure needs explicit return
  end

  # Loads both gem and library dependencies that are passed in as arguments.
  # Execution is deferred to the Merb::BootLoader::Dependencies.run during bootup.
  #
  # ==== Depecated (1.1) 
  # Dependency handling on the Framework level have been deprecated and
  # all the related API will be removed in the 2.0 release.
  #
  # Please use Bundler to manage your dependencies. Use tools provided
  # in RubyGems to define your dependencies in the Rakefiles or gemspecs
  # for your gems, plugins or slices.
  #
  # ==== Parameters
  # *args<String, Hash, Array> The dependencies to load.
  #
  # ==== Returns
  # Array[(Gem::Dependency, Array[Gem::Dependency])]:: Gem::Dependencies for the
  #   dependencies specified in args.
  #
  # :api: public
  # @deprecated
  def dependencies(*args)
    args.map do |arg|
      case arg
      when String then dependency(arg)
      when Hash   then arg.map { |r,v| dependency(r, v) }
      when Array  then arg.map { |r|   dependency(r)    }
      end
    end
  end

  # Loads both gem and library dependencies that are passed in as arguments.
  #
  # @param *args<String, Hash, Array> The dependencies to load.
  #
  # @note
  #   Each argument can be:
  #   String:: Single dependency.
  #   Hash::
  #     Multiple dependencies where the keys are names and the values versions.
  #   Array:: Multiple string dependencies.
  #
  # @example dependencies "RedCloth"                 # Loads the the RedCloth gem
  # @example dependencies "RedCloth", "merb_helpers" # Loads RedCloth and merb_helpers
  # @example dependencies "RedCloth" => "3.0"        # Loads RedCloth 3.0
  #
  # :api: private
  def load_dependencies(*args)
    args.map do |arg|
      case arg
      when String then load_dependency(arg)
      when Hash   then arg.map { |r,v| load_dependency(r, v) }
      when Array  then arg.map { |r|   load_dependency(r)    }
      end
    end
  end
  
  # chain use_orm in order to autoload the required dependencies
  def use_orm(orm, &blk)
    Merb.orm = orm
    begin
      orm_plugin = "merb_#{orm}"
      Kernel.dependency(orm_plugin, &blk)
    rescue LoadError => e
      Merb.logger.warn!("The #{orm_plugin} gem was not found.  You may need to install it.")
      raise e
    end
    nil
  end

  # chain use_testing_framework in order to autoload the required dependencies
  def use_testing_framework(test_framework, *test_dependencies)
    Merb.test_framework = test_framework
    Kernel.dependencies test_dependencies if Merb.env == "test" || Merb.env.nil?
    nil
  end

  # chain use_template_engine in order to autoload the required dependencies
  def use_template_engine(template_engine, &blk)
    Merb.template_engine = template_engine
    if template_engine != :erb
      if template_engine.in?(:haml, :builder)
        template_engine_plugin = "merb-#{template_engine}"
      else
        template_engine_plugin = "merb_#{template_engine}"
      end
      Kernel.dependency(template_engine_plugin, &blk)
    end
    nil
  rescue LoadError => e
    Merb.logger.warn!("The #{template_engine_plugin} gem was not found.  You may need to install it.")
    raise e
  end
end
