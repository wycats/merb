require File.dirname(__FILE__) + '/freezer_mode'

class Freezer
  include FreezerMode
   
    @@components = 
                  {
                    "core" => "git://github.com/wycats/merb-core.git",
                    "more" => "git://github.com/wycats/merb-more.git",
                    "plugins" => "git://github.com/wycats/merb-plugins.git"
                  }
  
    @@framework_dir = File.join(Dir.pwd, "framework")

    # Returns the components to freeze
    # a class variable is used so we could decide to add a setter and support custom components
    def self.components
      @@components
    end
  
    def self.framework_dir
      @@framework_dir
    end

    # Freezes a component
    #
    # ==== Parameters
    # component<String>::
    #   The component to freeze, it needs to be defined in @@components
    # update<Boolean>:: An optional value to tell the freezer to update the previously frozen or not, this will default to false
    # mode<String>:: An optional value to tell the freezer what freezer mode to use (submodules or rubygems), this will default to submodules
    #
    def self.freeze(component, update, mode)
      new(component, update, mode).freeze
    end

    # Initializes a Freeze instance
    #
    # ==== Parameters
    # component<String>::
    #   The component to freeze, it needs to be defined in @@components
    # update<Boolean>:: An optional value to tell the freezer to update the previously frozen or not, this will default to false
    # mode<String>:: An optional value to tell the freezer what freezer mode to use (submodules or rubygems), this will default to submodules
    #
  def initialize(component, update = false, mode = 'submodules')
    @component = "merb-" + component
    @update    = update
    @mode      = mode || 'submodules'
  end
    
  def freeze
    puts "freezing mode: #{@mode}"
    send("#{@mode}_freeze", @component, @update)
  end
  

end