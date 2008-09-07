$KCODE = 'UTF8'

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

# These are some examples of how you might specify dependencies.
# Dependency loading is delayed to a later Merb app
# boot stage, but it may be important when
# another part of your configuration relies on libraries specified
# here.
#
# dependencies "RedCloth", "merb_helpers"
# OR
# dependency "RedCloth", "> 3.0"
# OR
# dependencies "RedCloth" => "> 3.0", "ruby-aes-cext" => "= 1.0"
Merb::BootLoader.after_app_loads do
  # Add dependencies here that must load after the application loads:

  # dependency "magic_admin" # this gem uses the app's model classes
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


#
# ==== Set up your basic configuration
#

# IMPORTANT:
#
# early on Merb boot init file is not yet loaded.
# Thus setting PORT, PID FILE and ADAPTER using init file does not
# make sense and only can lead to confusion because default settings
# will be used instead.
#
# Please use command line options for them.
# See http://wiki.merbivore.com/pages/merb-core-boot-process
# if you want to know more.
Merb::Config.use do |c|

  # Sets up a custom session id key which is used for the session persistence
  # cookie name.  If not specified, defaults to '_session_id'.
  # c[:session_id_key] = '_session_id'
  
  # The session_secret_key is only required for the cookie session store.
  c[:session_secret_key]  = '<%= SHA1.new(rand(100000000000).to_s).to_s %>'
  
  # There are various options here, by default Merb comes with 'cookie', 
  # 'memory', 'memcache' or 'container'.  
  # You can of course use your favorite ORM instead: 
  # 'datamapper', 'sequel' or 'activerecord'.
  c[:session_store] = 'cookie'
end


# ==== Tune your inflector

# To fine tune your inflector use the word, singular_word and plural_word
# methods of English::Inflect module metaclass.
#
# Here we define erratum/errata exception case:
#
# English::Inflect.word "erratum", "errata"
#
# In case singular and plural forms are the same omit
# second argument on call:
#
# English::Inflect.word 'information'
#
# You can also define general, singularization and pluralization
# rules:
#
# Once the following rule is defined:
# English::Inflect.rule 'y', 'ies'
#
# You can see the following results:
# irb> "fly".plural
# => flies
# irb> "cry".plural
# => cries
#
# Example for singularization rule:
#
# English::Inflect.singular_rule 'o', 'oes'
#
# Works like this:
# irb> "heroes".singular
# => hero
#
# Example of pluralization rule:
# English::Inflect.singular_rule 'fe', 'ves'
#
# And the result is:
# irb> "wife".plural
# => wives
