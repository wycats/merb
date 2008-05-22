desc "Show information on application slices"
task :slices => [ "slices:info" ]

namespace :slices do
  task :info do
    puts "Application slices:\n"
    Merb::Slices.each_slice do |slice|
      puts "#{slice.name} (v. #{slice.version}) - #{slice.description}\n"
    end    
  end
end