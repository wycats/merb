# Make the app's "gems" directory a place where gems are loaded from
Gem.clear_paths
Gem.path.unshift(Merb.root / "gems")

# Make the app's "lib" directory a place where ruby files get "require"d from
$LOAD_PATH.unshift(Merb.root / "lib")

<% require 'sha1' %>
Merb::Config.use do |c|
  
  ### Sets up a custom session id key, if you want to piggyback sessions of other applications
  ### with the cookie session store. If not specified, defaults to '_session_id'.
  # c[:session_id_key] = '_session_id'
  
  c[:session_secret_key]  = '<%= SHA1.new(rand(100000000000).to_s).to_s %>'
  c[:session_store] = 'cookie'
end  

### Merb doesn't come with database support by default.  You need
### an ORM plugin.  Install one, and uncomment one of the following lines,
### if you need a database.

### Uncomment for DataMapper ORM
# use_orm :datamapper

### Uncomment for ActiveRecord ORM
# use_orm :activerecord

### Uncomment for Sequel ORM
# use_orm :sequel


### This defines which test framework the generators will use
### rspec is turned on by default
###
### Note that you need to install the merb_rspec if you want to ue
### rspec and merb_test_unit if you want to use test_unit. 
### merb_rspec is installed by default if you did gem install
### merb.
###
# use_test :test_unit
use_test :<%= assigns[:test_type] %><%= ", 'merb_test_unit'" if assigns[:test_type] == "test_unit" %>

### Add your other dependencies here

# These are some examples of how you might specify dependencies.
# 
# dependencies "RedCloth", "merb_helpers"
# OR
# dependency "RedCloth", "> 3.0"
# OR
# dependencies "RedCloth" => "> 3.0", "ruby-aes-cext" => "= 1.0"

Merb::BootLoader.after_app_loads do
  ### Add dependencies here that must load after the application loads:

  # dependency "magic_admin" # this gem uses the app's model classes
end
