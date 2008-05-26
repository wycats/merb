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
  
end