MAIN_BINDING = binding unless defined?(MAIN_BINDING)

module Merb::GeneratorHelpers
  
  # Remove "template/" from a file name
  # 
  # ==== Parameters
  # +path+<String>:: the path to relative-ize
  # +dir+<String>::  a prefix directory to add into the relative-ized path
  # 
  # ==== Returns
  # String:: a relative-ized path
  def relative(path, dir = nil)
    path.gsub(/^#{base}\/templates(\/#{dir ? dir + "/" : ""})?/, "")
  end
  
  def interpolate_path(path)
    path.gsub(/%([^\}]*)%/) {|x| assigns[$1.to_sym]}
  end  
  
  # Establishes the directories of the template layout
  def copy_dirs
    select_template_directories.map { |x| relative(x) }.each do |path|
      m.directory interpolate_path(path)
    end
  end
  
  # Copies all files within each directory of the template layout
  def copy_files
    select_template_directories(true).each do |file|
      # Remove "template/" from the glob filename
      dir = relative(file)
      
      # Get all the files under the directory that are not directories or in 
      # the list of excluded templates above.
      files = Dir["#{file.empty? ? "." : file}/*"].reject { |f| File.directory?(f) }
      
      next if files.empty?
      
      # We want to templatize any files that contain <% %> characters
      #--
      # This is old code, should we need it: 
      # templates, to_copy = files.partition {|file| !(file =~ /\.erb$/) && File.read(file) =~ /<%.*%>/}
      templates, to_copy = files.partition { |file| File.read(file) =~ /<%.*%>/ }
      
      # Make the paths relative to the directory we're inspecting
      [to_copy, templates].each do |paths|
        paths.map! { |f| relative(f, dir) }
      end
      
      # Copy the files over
      to_copy.each do |filename|
        m.file(
          file_name(dir, filename), 
          file_name(interpolate_path(dir), filename)
        )
      end

      # Copy the templates over
      templates.each do |filename|
        m.template(
          file_name(dir, filename), 
          file_name(interpolate_path(dir), interpolate_path(filename))
        )
      end
    end
  end
  
private
  
  # Selects all *directories* in the 'templates' folder. This accounts for 
  # +choices+ and +options+.
  # 
  # ==== Arguments
  # +with_root+<true,false>:: whether or not to include the base/templates 
  #                           directory
  # 
  # ==== Returns
  # Array:: all directories found in the 'templates' folder.
  def select_template_directories(with_root=false)
    selected = Dir["#{base}/templates/**/*"].compact.select do |f|
      File.directory?(f) && 
      (!choices.include?(relative(f)) || options[relative(f)])
    end
    selected += ["#{base}/templates"] if with_root
    return selected
  end
  
  # This was extracted from +copy_files+. It appears to do the same thing as 
  # File.join, but it doesn't account for the OS.
  # 
  # ==== Arguments
  # +dir+<String>::  the directory to place the file in
  # +name+<String>:: the name of said file
  # 
  # ==== Returns
  # String:: a string representing the path for some file
  # 
  # ==== Examples
  #   > file_name("folder", "some_file.txt")
  #   => "folder/some_file.txt"
  #   > file_name("", "some_file.txt")
  #   => "some_file.txt"
  def file_name(dir, name)
    "#{dir}#{"/" unless dir.empty?}#{name}"
  end
    
end