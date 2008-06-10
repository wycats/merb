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

    # ==== Returns
    # Array[Class]:: Classes that inherit from Merb::PartController.
    def self.subclasses_list() _subclasses end

    # ==== Parameters
    # action<~to_s>:: The name of the action that will be rendered.
    # type<~to_s>::
    #    The mime-type of the template that will be rendered. Defaults to html.
    # controller<~to_s>::
    #   The name of the controller that will be rendered. Defaults to
    #   controller_name.
    #
    # ==== Returns
    # String:: The template location, i.e. ":controller/:action.:type".
    def _template_location(action, type = :html, controller = controller_name)
      "#{controller}/#{action}.#{type}"
    end
    
    # The location to look for a template and mime-type. This is overridden 
    # from AbstractController, which defines a version of this that does not 
    # involve mime-types.
    #
    # ==== Parameters
    # template<String>:: 
    #    The absolute path to a template - without mime and template extension.
    #    The mime-type extension is optional - it will be appended from the 
    #    current content type if it hasn't been added already.
    # type<~to_s>::
    #    The mime-type of the template that will be rendered. Defaults to nil.
    #
    # @public
    def _absolute_template_location(template, type)
      template.match(/\.#{type.to_s.escape_regexp}$/) ? template : "#{template}.#{type}"
    end

    # Sets the template root to the default parts view directory.
    #
    # ==== Parameters
    # klass<Class>::
    #   The Merb::PartController inheriting from the base class.
    def self.inherited(klass)
      _subclasses << klass.to_s
      super
      klass._template_root = Merb.dir_for(:part) / "views" unless self._template_root
    end

    # ==== Parameters
    # web_controller<Merb::Controller>:: The controller calling this part.
    # opts<Hash>:: Additional options for this part.
    def initialize(web_controller, opts = {})
      @web_controller = web_controller
      @params = @web_controller.params.dup
      @params.merge!(opts) unless opts.empty?
      super
      @content_type = @web_controller.content_type
    end

    # ==== Parameters
    # action<~to_s>:: An action to dispatch to. Defaults to :to_s.
    #
    # ==== Returns
    # String:: The part body.
    def _dispatch(action=:to_s)
      action = action.to_s
      self.action_name = action
      super(action)
      @body
    end

    # Send any methods that are missing back up to the web controller
    # Patched to set partial locals on the web controller
    def method_missing(sym, *args, &blk)
      @web_controller.instance_variable_set(:@_merb_partial_locals, @_merb_partial_locals)
      @web_controller.send(sym, *args, &blk)
    end
  end
end
