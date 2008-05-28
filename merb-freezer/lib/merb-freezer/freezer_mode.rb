require 'find'
#require 'merb-core/tasks/merb_rake_helper'
module FreezerMode
  
  def sudo
    windows = (PLATFORM =~ /win32|cygwin/) rescue nil
    sudo = windows ? "" : "sudo"
  end

  def gitmodules
    File.join(Dir.pwd, ".gitmodules")
  end

  # Uses the Git submodules to freeze a component
  #
  def submodules_freeze
    # Ensure that required git commands are available
    %w(git-pull git-submodule).each do |bin|
      next if in_path?(bin)
      $stderr.puts "ERROR: #{bin} must be avaible in PATH - you might want to freeze using MODE=rubygems"
      exit 1
    end

    # Create directory to receive the frozen components
    create_freezer_dir(freezer_dir)

    if managed?(@component)
      puts "#{@component} seems to be already managed by git-submodule."
      if @update
        puts "Trying to update #{@component} ..."
        `cd #{freezer_dir}/#{@component} && git-pull`
      else
        puts "you might want to call this rake task using UPDATE=true if you wish to update the frozen gems using this task"
      end
    else
      puts "Creating submodule for #{@component} ..."
      if framework_component?
        `cd #{Dir.pwd} & git-submodule --quiet add #{Freezer.components[@component.gsub("merb-", '')]} #{File.basename(freezer_dir)}/#{@component}`
      else
        `cd #{Dir.pwd} & git-submodule --quiet add #{@component} gems/submodules/#{@component.match(/.*\/(.*)\..{3}$/)[1]}`
      end
      if $?.success?
        `git-submodule init`
      else
        # Should this instead be a raise?
        $stderr.puts("ERROR: unable to create submodule for #{@component} - you might want to freeze using MODE=rubygems")
      end
    end
  end

  # Uses rubygems to freeze the components locally
  #
  def rubygems_freeze
    create_freezer_dir(freezer_dir)
    action = update ? 'update' : 'install'
    puts "#{action} #{@component} and dependencies from rubygems"
    if File.exist?(freezer_dir) && !File.writable?("#{freezer_dir}/cache")
      puts "you might want to CHOWN the gems folder so it's not owned by root: sudo chown -R #{`whoami`} #{freezer_dir}"
      `#{sudo} gem #{action} #{@component} --no-rdoc --no-ri -i #{freezer_dir}`
    else
      `gem #{action} #{@component} --no-rdoc --no-ri -i #{freezer_dir}`
    end
  end

  def create_freezer_dir(path)
    unless File.directory?(path)
      puts "Creating freezer directory ..."
      FileUtils.mkdir_p(path)
    end
  end

  protected

  # returns true if submodules are used
  def in_submodule?(component)
    return false unless File.exists?(gitmodules)
    # File.read(gitmodules) =~ %r![submodule "#{freezer_dir}/#{component}"]!
    File.read(gitmodules).match(%r!#{freezer_dir}/#{component}!)
  end

  # returns true if the component is in a submodule
  def managed?(component)
    File.directory?(File.join(freezer_dir, component)) || in_submodule?(component)
  end

  def in_path?(bin)
    `which #{bin}`
    !$?.nil? && $?.success?
  end

end
