#
# ==== Structure of Merb initializer
#
# 1. Load paths.
# 2. Dependencies configuration.
# 3. Libraries (ORM, testing tool, etc) you use.
# 4. Application-specific configuration.

#
# ==== Set up load paths
#

# Add the app's "gems" directory to the gem load path.
# Note that the gems directory must mirror the structure RubyGems uses for
# directories under which gems are kept.
#
# To conveniently set it up, use gem install -i <merb_app_root/gems>
# when installing gems. This will set up the structure under /gems
# automagically.
#
# An example:
#
# You want to bundle ActiveRecord and ActiveSupport with your Merb
# application to be deployment environment independent. To do so,
# install gems into merb_app_root/gems directory like this:
#
# gem install -i merb_app_root/gems activesupport-post-2.0.2.gem activerecord-post-2.0.2.gem
#
# Since RubyGems will search merb_app_root/gems for dependencies, order
# in the statement above is important: we need to install ActiveSupport which
# ActiveRecord depends on first.
#
# Remember that bundling of dependencies as gems with your application
# makes it independent of the environment it runs in and is a very
# good, encouraged practice to follow.

# If you want modules and classes from libraries organized like
# merbapp/lib/magicwand/lib/magicwand.rb to autoload,
# uncomment this.
# Merb.push_path(:lib, Merb.root / "lib") # uses **/*.rb as path glob.

# ==== Dependencies

# These are a few, but not all, of the standard merb-more dependencies:
#
# dependency "merb-action-args"   # Provides support for querystring arguments to be passed in to controller actions
# dependency "merb-assets"        # Provides link_to, asset_path, auto_link, image_tag methods (and lots more)
# dependency "merb-helpers"       # Provides the form, date/time, and other helpers
# dependency "merb-cache"         # Provides your application with caching functions 
# dependency "merb-haml"          # Adds rake tasks and the haml generators to your merb app
# dependency "merb-jquery"        # Provides a #jquery method to insert jQuery code in to a content block
# dependency "merb-mailer"        # Integrates mail support via Merb Mailer

# These are a few, but not all, of the merb-plugin dependencies:
#
# dependency "merb_param_protection"  # Lets you have better control over your query string params and param logging
# dependency "merb_stories"           # Provides rspec helper methods for your application

# Miscellaneous dependencies:
#
# Specify more than one dependency at a time with the #dependencies method:
# dependencies "RedCloth", "BlueCloth"

# Specify a specific version of a dependency
# dependency "RedCloth", "> 3.0"

# Specify more than one dependency at a time as well as the version:
# dependencies "RedCloth" => "> 3.0", "BlueCloth" => "= 1.0.0"

# You can also add in dependencies after your application loads.
Merb::BootLoader.after_app_loads do
  # For example, the magic_admin gem uses the app's model classes. This requires that the models be 
  # loaded already. So, we can put the magic_admin dependency here:
  # dependency "magic_admin"
end

#
# ==== Set up your ORM of choice
#

# Merb doesn't come with database support by default.  You need
# an ORM plugin.  Install one, and uncomment one of the following lines,
# if you need a database.

# Uncomment for DataMapper ORM
<%= "# " unless orm == :datamapper %>use_orm :datamapper

# Uncomment for ActiveRecord ORM
<%= "# " unless orm == :activerecord %>use_orm :activerecord

# Uncomment for Sequel ORM
<%= "# " unless orm == :sequel %>use_orm :sequel


#
# ==== Pick what you test with
#

# This defines which test framework the generators will use.
# RSpec is turned on by default.
#
# To use Test::Unit, you need to install the merb_test_unit gem.
# To use RSpec, you don't have to install any additional gems, since
# merb-core provides support for RSpec.
#
<%= "# " unless testing_framework == :test_unit %>use_test :test_unit
<%= "# " unless testing_framework == :rspec %>use_test :rspec


#
# ==== Choose which template engine to use by default
#

# Merb can generate views for different template engines, choose your favourite as the default.

<%= "# " unless template_engine == :erb %>use_template_engine :erb
<%= "# " unless template_engine == :haml %>use_template_engine :haml


# Move this to application.rb if you want it to be reloadable in dev mode.
Merb::Router.prepare do
  match('/').to(:controller => "<%= self.name.gsub("-", "_") %>", :action =>'index')

  default_routes
end

Merb::Config.use { |c|
  c[:environment]         = 'production',
  c[:framework]           = {},
  c[:log_level]           = :debug,
  c[:log_stream]          = STDOUT,
  # or use file for loggine:
  # c[:log_file]          = Merb.root / "log" / "merb.log",
  c[:use_mutex]           = false,
  c[:session_store]       = 'cookie',
  c[:session_id_key]      = '_session_id',
  c[:session_secret_key]  = '<%= SHA1.new(rand(100000000000).to_s).to_s %>',
  c[:exception_details]   = true,
  c[:reload_classes]      = true,
  c[:reload_templates]    = true,
  c[:reload_time]         = 0.5
}
