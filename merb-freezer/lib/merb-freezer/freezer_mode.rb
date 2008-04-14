module FreezerMode
  
  windows = (PLATFORM =~ /win32|cygwin/) rescue nil
  
  def sudo
    sudo = windows ? "" : "sudo"
  end
  
  def gitmodules
    File.join(Dir.pwd, ".gitmodules")
  end    
  
  # Uses the Git submodules to freeze a component
  #
  # ==== Parameters
  # component<String>:: The component to freeze
  # update<Boolean>:: An optional value to tell the freezer to update the previously frozen or not, this will default to false
  #
  def submodules_freeze(component, update=false)
    # Ensure that required git commands are available
    %w(git-pull git-submodule).each do |bin|
      next if in_path?(bin)
      $stderr.puts "ERROR: #{bin} must be avaible in PATH - you might want to freeze using MODE=rubygems"
      exit 1
    end

    create_framework_dir

    if managed?
      puts "#{component} seems to be already managed by git-submodule."
      if @update
        puts "Trying to update #{component} ..."
        `cd #{Freezer.framework_dir}/#{component} && git-pull`
      else
        puts "you might want to call this rake task using UPDATE=true if you wish to update the frozen gems using this task"
      end
    else
      puts "Creating submodule for #{component} ..."
      `git-submodule add #{Freezer.components[component.gsub("merb-", '')]} #{Dir.pwd}/#{File.basename(Freezer.framework_dir)}/#{component}` 
      if $?.success?
        `("git-submodule init")`
      else
        # Should this instead be a raise?
        $stderr.puts("ERROR: unable to create submodule for #{component} - you might want to freeze using MODE=rubygems")
      end
    end
  end
  
  # Uses rubygems to freeze the components locally
  #
  # ==== Parameters
  # component<String>:: The component to freeze
  # update<Boolean>:: An optional value to tell the freezer to update the previously frozen or not, this will default to false
  #
  def rubygems_freeze(component, update)
    create_framework_dir
    action = update ? 'update' : 'install'
    puts "#{action} #{component} and dependencies from rubygems"
    `#{@sudo} gem #{action} #{component} --no-rdoc --no-ri -i framework`
  end
  
  def create_framework_dir
    unless File.directory?(Freezer.framework_dir)
      puts "Creating framework directory ..."
      FileUtils.mkdir_p(Freezer.framework_dir)
    end
  end
  
  protected

  # returns true if submodules are used
  def in_submodule?
    return false unless File.exists?(gitmodules)
    File.read(gitmodules) =~ %r![submodule "#{framework_dir}/#{@component}"]!
  end

  # returns true if the component is in a submodule
  def managed?
    File.directory?(File.join(Freezer.framework_dir, @component)) || in_submodule?
  end
  
  def in_path?(bin)
    `which #{bin}`
    !$?.nil? && $?.success?
  end
  
end