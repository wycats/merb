require 'rubygems'

# use local merb-core if running from a typical dev checkout.
lib = File.join('..', '..', 'merb-core', 'lib')
$LOAD_PATH.unshift(lib) if File.directory?(lib)

require 'merb-core'
require 'merb-core/test'
require 'merb-core/dispatch/session'

# use local merb-auth-core if running from a typical dev checkout.
lib = File.join('..', 'merb-auth-core', 'lib')
$LOAD_PATH.unshift(lib) if File.directory?(lib)

require 'merb-auth-core'

# Support running specs with 'rake spec' and 'spec'
$LOAD_PATH.unshift('lib')  unless $LOAD_PATH.include?('lib')
$LOAD_PATH.unshift('spec') unless $LOAD_PATH.include?('spec')

# Satisfies Autotest and anyone else not using the Rake tasks
require 'spec'

require 'shared_user_spec'

$TESTING=true

Merb.start(
  :environment        => "test",
  :adapter            => "runner",
  :session_store      => "cookie",
  :session_secret_key => "d3a6e6f99a25004da82b71af8b9ed0ab71d3ea21"
)

module StrategyHelper
  def clear_strategies!
    Merb::Authentication.strategies.each do |s|
      begin
        Object.class_eval{ remove_const(s.name) if defined?(s)}
      rescue
      end
    end
    Merb::Authentication.strategies.clear
    Merb::Authentication.default_strategy_order.clear
  end
end

Spec::Runner.configure do |config|
  config.include(Merb::Test::ViewHelper)
  config.include(Merb::Test::RouteHelper)
  config.include(Merb::Test::ControllerHelper)
  config.include(StrategyHelper)
end