$SLICED_APP=true # we're running inside the host application context

namespace :slices do
  namespace :<%= underscored_name %> do
  
    desc "Install <%= module_name %>"
    task :install => [:preflight, :setup_directories, :copy_assets, :migrate] do
    end
    
    desc "Test for any dependencies"
    task :preflight do
      # implement this to test for structural/code dependencies
      # like certain directories or availability of other files
    end
  
    desc "Setup directories"
    task :setup_directories do
      puts "Creating directories for host application"
      [:view, :model, :controller, :helper, :mailer, :part, :public].each do |type|
        if File.directory?(<%= module_name %>.dir_for(type))
          if !File.directory?(dst_path = <%= module_name %>.app_dir_for(type))
            relative_path = dst_path.relative_path_from(Merb.root)
            puts "- creating directory :#{type} #{File.basename(Merb.root) / relative_path}"
            mkdir_p(dst_path)
          end
        end
      end
    end 
  
    desc "Copy public assets to host application"
    task :copy_assets do
      puts "Copying assets for <%= module_name %> - do not edit these as the will be overwritten!"
      [:image, :javascript, :stylesheet].each do |type|
        src_path = <%= module_name %>.dir_for(type)
        dst_path = <%= module_name %>.app_dir_for(type)
        Dir[src_path / '**/*'].each do |file|
          relative_path = file.relative_path_from(src_path)
          puts "- installing :#{type} #{relative_path}"
          mkdir_p(dst_path / File.dirname(relative_path))
          copy_entry(file, dst_path / relative_path, false, false, true)
        end
      end
    end
    
    desc "Migrate the database"
    task :migrate do
      # implement this to perform any database related setup steps
    end
    
    desc "Run slice specs within the host application context"
    task :spec => [ "spec:explain", "spec:default" ]
    
    namespace :spec do
      
      slice_root = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))
      
      task :explain do
        puts "\nNote: By running <%= module_name %> specs inside the application context any\n" +
             "overrides could break existing specs. This isn't always a problem,\n" +
             "especially in the case of views. Use these spec tasks to check how\n" +
             "well your application conforms to the original slice implementation."
      end
      
      Spec::Rake::SpecTask.new('default') do |t|
        t.spec_opts = ["--format", "specdoc", "--colour"]
        t.spec_files = Dir["#{slice_root}/spec/**/*_spec.rb"].sort
      end

      desc "Run all model specs, run a spec for a specific Model with MODEL=MyModel"
      Spec::Rake::SpecTask.new('model') do |t|
        t.spec_opts = ["--format", "specdoc", "--colour"]
        if(ENV['MODEL'])
          t.spec_files = Dir["#{slice_root}/spec/models/**/#{ENV['MODEL']}_spec.rb"].sort
        else
          t.spec_files = Dir["#{slice_root}/spec/models/**/*_spec.rb"].sort
        end
      end

      desc "Run all controller specs, run a spec for a specific Controller with CONTROLLER=MyController"
      Spec::Rake::SpecTask.new('controller') do |t|
        t.spec_opts = ["--format", "specdoc", "--colour"]
        if(ENV['CONTROLLER'])
          t.spec_files = Dir["#{slice_root}/spec/controllers/**/#{ENV['CONTROLLER']}_spec.rb"].sort
        else    
          t.spec_files = Dir["#{slice_root}/spec/controllers/**/*_spec.rb"].sort
        end
      end

      desc "Run all view specs, run specs for a specific controller (and view) with CONTROLLER=MyController (VIEW=MyView)"
      Spec::Rake::SpecTask.new('view') do |t|
        t.spec_opts = ["--format", "specdoc", "--colour"]
        if(ENV['CONTROLLER'] and ENV['VIEW'])
          t.spec_files = Dir["#{slice_root}/spec/views/**/#{ENV['CONTROLLER']}/#{ENV['VIEW']}*_spec.rb"].sort
        elsif(ENV['CONTROLLER'])
          t.spec_files = Dir["#{slice_root}/spec/views/**/#{ENV['CONTROLLER']}/*_spec.rb"].sort
        else
          t.spec_files = Dir["#{slice_root}/spec/views/**/*_spec.rb"].sort
        end
      end

      desc "Run all specs and output the result in html"
      Spec::Rake::SpecTask.new('html') do |t|
        t.spec_opts = ["--format", "html"]
        t.libs = ['lib', 'server/lib' ]
        t.spec_files = Dir["#{slice_root}/spec/**/*_spec.rb"].sort
      end
      
    end
    
  end
end