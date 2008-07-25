# Usage: sake merb:clone
desc "Clone a copy of all 3 of the Merb repositories"
task 'merb:clone' do
  if File.exists?("merb")
    puts "./merb already exists!"
    exit
  end
  require 'fileutils'
  mkdir "merb"
  cd "merb"
  %w[core more plugins extlib].collect {|r| "merb-#{r}"}.each do |r|
    sh "git clone git://github.com/wycats/#{r}.git"
  end
end

# Usage: sake merb:update
desc "Update your local Merb repositories.  Run from inside the top-level merb directory."
task 'merb:update' do
  repos = %w[core more plugins extlib].collect {|r| "merb-#{r}"}
  repos.each do |r|
    unless File.exists?(r)
      puts "#{r} missing ... did you use merb:clone to set this up?"
      exit
    end
  end

  repos.each do |r|
    cd r
    sh "git fetch"
    sh "git checkout master"
    sh "git rebase origin/master"
    cd ".."
  end
end

# Usage: sake merb:gems:wipe
desc "Uninstall all RubyGems related to Merb"
task 'merb:gems:wipe' do
  windows = (PLATFORM =~ /win32|cygwin/) rescue nil
  sudo = windows ? "" : "sudo"
  %w[ merb merb-extlib merb-core merb-more merb-action-args merb-assets merb-builder merb-cache merb-freezer merb-gen merb-haml merb-mailer merb-parts merb_activerecord merb_helpers merb_sequel merb_param_protection merb_test_unit merb_stories].each do |gem|
    sh "#{sudo} gem uninstall #{gem} --all --ignore-dependencies --executables; true"
  end
end

# Usage: sake merb:gems:refresh
desc "Pull fresh copies of Merb, uninstall existing gems, and re-install all the gems"
task 'merb:gems:refresh' => ["merb:gems:wipe", "merb:update", "merb:install"]

# Usage: sake merb:install:merb-extlib
desc "Install merb-extlib"
task 'merb:install:extlib' do
  cd 'merb-extlib'
  sh "rake install"
  cd '..'
end

# Usage: sake merb:install:core
desc "Install merb-core"
task 'merb:install:core' do
  cd 'merb-core'
  sh "rake install"
  cd '..'
end

# Usage: sake merb:install:more
desc "Install merb-more"
task 'merb:install:more' do
  cd 'merb-more'
  sh "rake install"
  cd '..'
end

# Usage: sake merb:install:plugins
desc "Install merb-plugins"
task 'merb:install:plugins' do
  cd 'merb-plugins'
  sh "rake install"
  cd '..'
end

# Usage: sake merb:install
desc "Install merb-core, merb-more, and merb-plugins"
task 'merb:install' => ["merb:install:extlib", "merb:install:core", "merb:install:more", "merb:install:plugins"]

# Usage: sake merb:sake:refresh
desc "Remove and reinstall Merb sake recipes"
task "merb:sake:refresh" do
  %w[clone update gems:wipe gems:refresh
    install install:core install:more sake:refresh].each {|t|
    sh "sake -u merb:#{t}"
  }
  sh "sake -i http://merbivore.com/merb-dev.sake"
end


desc "Remove these merb-dev sake tasks.  Including this one."
task "merb:sake:uninstall" do
  sh "sake -u merb:gems:wipe merb:clone merb:gems:refresh merb:install merb:install:core merb:install:more merb:install:plugins merb:sake:refresh merb:update merb:sake:uninstall"
end
