require "rubygems/dependency_installer"

desc "Show information on application slices"
task :slices => [ "slices:list" ]

namespace :slices do

  desc "Get a suitable slices environment up"
  task :env do
    Merb::Slices.register_slices_from_search_path!
  end

  desc "List known slices for the current application"
  task :list => [:env] do
    puts "Application slices:\n"
    Merb::Slices.each_slice do |slice|
      puts "#{slice.name} (v. #{slice.version}) - #{slice.description}\n"
    end    
  end
  
  desc "Install a slice into the local gems dir (GEM=your-slice)"
  task :install_as_gem do
    if ENV['GEM']
      ENV['GEM_DIR'] ||= File.join(Merb.root, 'gems')
      puts "Installing #{ENV["GEM"]} as a local gem"
      install_gem(ENV['GEM_DIR'], ENV['GEM'], ENV['VERSION'])
    else
      puts "No slice GEM specified"
    end
  end
  
  # Install a gem - looks remotely and locally; won't process rdoc or ri options.
  def install_gem(install_dir, gem, version = nil)
    Gem.configuration.update_sources = false
    Gem.clear_paths # default to plain rubygems path
    installer = Gem::DependencyInstaller.new(:install_dir => install_dir)
    exception = nil
    begin
        installer.install gem, version
      rescue Gem::InstallError => e
        exception = e
      rescue Gem::GemNotFoundException => e
      puts "Locating #{gem} in local gem path cache..."
      spec = if version
        Gem.source_index.find_name(gem, "= #{version}").first
      else
        Gem.source_index.find_name(gem).sort_by { |g| g.version }.last
      end
      if spec && File.exists?(gem_file = 
        File.join(spec.installation_path, 'cache', "#{spec.full_name}.gem"))
        installer.install gem_file
      end
      exception = e
    end
    if installer.installed_gems.empty? && e
      puts "Failed to install gem '#{gem}' (#{e.message})"
    end
    installer.installed_gems.each do |spec|
      puts "Successfully installed #{spec.full_name}"
    end
  end
  
end