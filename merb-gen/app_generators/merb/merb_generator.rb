class MerbGenerator < RubiGen::Base
  DEFAULT_SHEBANG = File.join(Config::CONFIG['bindir'],
                              Config::CONFIG['ruby_install_name']) unless defined? DEFAULT_SHEBANG
  
  default_options   :shebang => DEFAULT_SHEBANG
  
  attr_reader :name
  
  def initialize(runtime_args, runtime_options = {})
    super
    usage if args.empty?
    @name = args.shift
    @destination_root = File.expand_path(@name)
    extract_options
  end

  def relative(path, dir = nil)
    path.gsub(/^#{File.dirname(__FILE__)}\/templates\/#{dir}/, "")
  end

  def manifest
    script_options     = { :chmod => 0755, :shebang => options[:shebang] == DEFAULT_SHEBANG ? nil : options[:shebang] }

    record do |m|
      m.directory ''
      
      options["spec"] = true unless options["test"]
      
      # Things that are optional and should only be included if options[choice] is true
      choices = %w( spec test )      
      
      # Make sure the appropriate folders exist
      basedirs = Dir["#{File.dirname(__FILE__)}/templates/**/*"].
        select {|x| File.directory?(x) && (!choices.include?(relative(x)) || options[relative(x)]) }.
        map {|x| relative(x) }
      
      basedirs.each { |path| m.directory path }
      
      # copy skeleton
      # Grab everything under templates
      Dir["#{File.dirname(__FILE__)}/templates/**/*"].each do |file|
        # Only continue if the file is a directory
        next unless File.directory?(file)
        next if (choices.include?(relative(file)) && !options[relative(file)])
        # Remove "template/" from the glob filename
        dir = relative(file)
        # Get all the files under the directory that are not directories or in the list of excluded templates above.
        # Then, remove "template/" from the resulting filenames
        files = Dir["#{file}/*"].reject {|f| File.directory?(f)}.map {|f| relative(f, "#{dir}/") }
        # Copy the files over
        m.file_copy_each(files, dir) unless files.empty?
      end

      # m.template "config/merb.yml", "config/merb.yml", :assigns => {:key => "#{@name.upcase}#{rand(9999)}"}
    end
  end
  
  def windows
    (RUBY_PLATFORM =~ /dos|win32|cygwin/i) || (RUBY_PLATFORM =~ /(:?mswin|mingw)/)
  end
  
  protected
    def banner
      <<-EOS.split("\n").map{|x| x.strip}.join("\n")
        Creates a Merb application stub.

        USAGE: #{spec.name} -g path"
      EOS
    end

    def add_options!(opts)
      opts.on("-S", "--[no-]spec", "Generate with RSpec") {|s| @options["spec"] = true}
      opts.on("-T", "--[no-]test", "Generate with Test::Unit") {|t| @options["test"] = true}
    end
    
    def extract_options
    end

    def parse!(args, runtime_options = {})
      self.options = {}

      @option_parser = OptionParser.new do |opt|
        opt.banner = banner
        add_options!(opt)
        add_general_options!(opt)
        opt.parse!(args)
      end

      return args
    ensure
      self.options = full_options(runtime_options)
    end
    
end
