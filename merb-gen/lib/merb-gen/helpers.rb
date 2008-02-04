MAIN_BINDING = binding unless defined?(MAIN_BINDING)

module Merb::GeneratorHelpers
  def relative(path, dir = nil)
    path.gsub(/^#{base}\/templates(\/#{dir ? dir + "/" : ""})?/, "")
  end
  
  def interpolate_path(path)
    path.gsub(/%([^\}]*)%/) {|x| assigns[$1.to_sym]}
  end  
  
  def copy_dirs
    basedirs = Dir["#{base}/templates/**/*"].
      select {|x| File.directory?(x) && (!choices.include?(relative(x)) || options[relative(x)]) }.
      map {|x| relative(x) }

    basedirs.each do |path|
      m.directory interpolate_path(path)
    end
  end
  
  def copy_files
    (Dir["#{base}/templates/**/*"] + Dir["#{base}/templates"]).each do |file|
      
      # Only continue if the file is a directory
      next unless File.directory?(file)
      
      # Skip it if it's a choice (rspec vs. test/unit, for instance), and options["spec"] is not set.
      next if (choices.include?(relative(file)) && !options[relative(file)])
      
      # Remove "template/" from the glob filename
      dir = relative(file)
      
      # Get all the files under the directory that are not directories or in the list of excluded templates above.
      files = Dir["#{file}/*"].reject {|f| File.directory?(f)}
      
      next if files.empty?
      
      # We want to templatize any files that contain <% %> characters
      # templates, to_copy = files.partition {|file| !(file =~ /\.erb$/) && File.read(file) =~ /<%.*%>/}
      templates, to_copy = files.partition {|file| File.read(file) =~ /<%.*%>/}
      
      # Make the paths relative to the directory we're inspecting
      to_copy.map! {|f| relative(f, dir) }
      templates.map! {|f| relative(f, dir) }
      
      # Copy the files over
      to_copy.each do |file_name|
        m.file "#{dir}#{"/" unless dir.empty?}#{file_name}", 
          "#{interpolate_path(dir)}#{"/" unless dir.empty?}#{interpolate_path(file_name)}"
      end

      # Copy the templates over
      templates.each do |file_name|
        m.template "#{dir}#{"/" unless dir.empty?}#{file_name}", 
          "#{interpolate_path(dir)}#{"/" unless dir.empty?}#{interpolate_path(file_name)}", assigns
      end
    end
  end    
    
end