require File.dirname(__FILE__) + "/../merb-freezer"

task :freeze => Freezer.components.keys.map { |component| "freeze:#{component}" }
namespace :freeze do
  Freezer.components.each do |component, git_repository|
    desc "Freeze merb-#{component} from #{git_repository} or rubygems - use UPDATE=true to update a frozen component. By default this task uses git submodules. To freeze the latest gems versions use MODE=rubygems"
    task component do
      Freezer.freeze(component, ENV["UPDATE"], ENV["MODE"])
    end
  end
end