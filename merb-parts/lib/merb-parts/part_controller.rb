require File.join(File.dirname(__FILE__), "mixins", "web_controller")
module Merb
  
  # A Merb::PartController is a light weight way to share logic and templates
  # amongst controllers.  
  # Merb::PartControllers work just like Merb::controller.  
  # There is a filter stack, layouts (if needed) all the render functions,
  # and url generation.  
  #
  # Cookies, params, and even the request object are shared with the web controller  
  class PartController < AbstractController
    include Merb::Mixins::WebController
    
    attr_reader :params
    
    cattr_accessor :_subclasses
    self._subclasses = Set.new
    def self.subclasses_list() _subclasses end
    
    self._template_root = Merb.dir_for(:part) / "views"
    
    def _template_location(action, type = nil, controller = controller_name)
      "#{controller}/#{action}.#{type}"
    end
  
    def self.inherited(klass)
      _subclasses << klass.to_s
      super
    end

    def initialize(web_controller, opts = {})
      @web_controller = web_controller
      @params = @web_controller.params
      @params.merge!(opts) unless opts.empty?
      super
      @content_type = @web_controller.content_type
    end

    def _dispatch(action=:to_s)
      self.action_name = action
      super(action)
      @body
    end    
    
    # Send any methods that are missing back up to the web controller
    def method_missing(sym, *args, &blk)
      @web_controller.send(sym, *args, &blk)
    end    
  end
end