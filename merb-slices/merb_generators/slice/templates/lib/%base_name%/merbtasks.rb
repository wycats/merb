namespace :<%= underscored_name %> do
  
  desc "Install <%= module_name %>"
  task :install => [:setup_directories, :copy_assets] do
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
  
end