namespace :merb do

  task :check_outside_merb_dir do
    require 'fileutils'
    unless File.exists?('merb')
      puts "Error : Can't see 'merb' dir.  Are you in the right place?  You should be in the parent dir of 'merb'."
      exit
    end
  end

  # Usage: sake merb:clone
  desc 'Clone/Update all Merb repos. Will put them in the "merb" dir.'
  task :clone do

    require 'fileutils'

    if File.exists?('../merb')
      puts "Error : You appear to be running this from inside an existing 'merb' dir...  Run from OUTSIDE..."
      exit
    end

    unless File.exists?('merb')
      puts "Creating merb dir..."
      mkdir 'merb'
    end

    cd 'merb'

    %w[core more plugins].each do |r|
      if File.exists?("merb-#{r}")
        puts "\nmerb-#{r} repos exists! Updating instead of cloning..."
        cd "merb-#{r}"
        sh 'git fetch'
        sh 'git checkout master'
        sh 'git rebase origin/master'
        cd '..'
      else
        puts "\nCloning merb-#{r} repos..."
        sh "git clone git://github.com/wycats/merb-#{r}.git"
      end
    end

    if File.exists?("extlib")
      puts "\nextlib repos exists! Updating instead of cloning..."
      cd "extlib"
      sh 'git fetch'
      sh 'git checkout master'
      sh 'git rebase origin/master'
      cd '..'
    else
      puts "\nCloning extlib repos..."
      sh "git clone git://github.com/sam/extlib.git"
    end

    # bring us back to the parent dir so any chained tasks will work
    cd '..'

  end

  # Usage: sake merb:update
  desc 'Update clones of local Merb repos.  Run from OUTSIDE "merb" parent dir.'
  task :update => ['merb:check_outside_merb_dir', 'merb:clone']

  namespace :gems do

    # Usage: sake merb:gems:wipe
    desc 'Uninstall all RubyGems related to Merb'
    task :wipe do
      windows = (PLATFORM =~ /win32|cygwin/) rescue nil
      sudo = windows ? "" : 'sudo'
      %w[ merb extlib merb-core merb-more merb-action-args merb-assets merb-builder merb-cache merb-freezer merb-gen merb-haml merb-mailer merb-parts merb_activerecord merb_helpers merb_sequel merb_param_protection merb_test_unit merb_stories].each do |gem|
        sh "#{sudo} gem uninstall #{gem} --all --ignore-dependencies --executables; true"
      end
    end

    # Usage: sake merb:gems:refresh
    desc 'Pull fresh copies of Merb, uninstall existing gems, and re-install all the gems'
    task :refresh => ['merb:check_outside_merb_dir', 'merb:update', 'merb:gems:wipe', 'merb:install:all']

  end

  namespace :install do

    # Usage: sake merb:install:all
    desc 'Install merb-core, merb-more, and merb-plugins'
    task :all => ['merb:check_outside_merb_dir', 'merb:install:extlib', 'merb:install:core', 'merb:install:more', 'merb:install:plugins']

    # Usage: sake merb:install:core
    desc 'Install merb-core and extlib'
    task :core do
      puts "\nInstalling merb-core and extlib..."
      sh "cd merb/merb-core && rake install && cd ../.."
    end

    # Usage: sake merb:install:more
    desc 'Install merb-more'
    task :more do
      puts "\nInstalling merb-more..."
      sh "cd merb/merb-more && rake install && cd ../.."
    end

    # Usage: sake merb:install:plugins
    desc 'Install merb-plugins'
    task :plugins do
      puts "\nInstalling merb-plugins..."
      sh "cd merb/merb-plugins && rake install && cd ../.."
    end

    # Usage: sake merb:install:extlib
    desc 'Install extlib'
    task :extlib do
      puts "\nInstalling extlib..."
      sh "cd merb/extlib && rake install && cd ../.."
    end

  end

  namespace :sake do

    # Usage: sake merb:sake:refresh
    desc 'Remove and reinstall Merb sake recipes'
    task :refresh => ['merb:sake:uninstall'] do
      puts "\nInstalling merb-dev sake tasks..."
      sh 'sake -i http://merbivore.com/merb-dev.sake'
    end

    desc 'Remove all merb:* sake tasks. Including this one.'
    task :uninstall do
      puts "\nUninstalling merb-dev sake tasks..."
      sh 'sake -u merb:check_outside_merb_dir merb:gems:wipe merb:clone merb:gems:refresh merb:install merb:install:all merb:install:core merb:install:more merb:install:plugins merb:install:extlib merb:sake:refresh merb:update merb:sake:uninstall'
    end

  end

end

