namespace :merb do
  namespace :jquery do
    download_location = "http://jqueryjs.googlecode.com/files"
    latest_version = "1.2.6"
    task :required_stuff do
      require 'uri'
      require 'net/http'
      mkdir_p "public" / "javascripts"    
    end
    
    desc "Install uncompressed jQuery to public/javascripts/"
    task :install => :required_stuff do
      File.open("public" / "javascripts" / "jquery.js", "w+") do |f|
        f.write(Net::HTTP.get(URI.parse("#{download_location}/jquery-#{latest_version}.js")))
      end
    end

    desc "Install minified jQuery to public/javascripts/"
    task :install_minified => :required_stuff do
      File.open("public" / "javascripts" / "jquery.js", "w+") do |f|
        f.write(Net::HTTP.get(URI.parse("#{download_location}/jquery-#{latest_version}.min.js")))
      end
    end
  end
end
