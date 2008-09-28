module Merb::Cache::CacheMixin
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def cache!(conditions = {})
      before(:_cache_before, conditions.only(:if, :unless).merge(:with => conditions))
      after(:_cache_after, conditions.only(:if, :unless).merge(:with => conditions))
    end

    def cache(*actions)
      if actions.last.is_a? Hash
        cache_action(*actions)
      else
        actions.each {|a| cache_action(*a)}
      end
    end

    def cache_action(action, conditions = {})
      before("_cache_#{action}_before", conditions.only(:if, :unless).merge(:with => [conditions], :only => action))
      after("_cache_#{action}_after", conditions.only(:if, :unless).merge(:with => [conditions], :only => action))
      alias_method "_cache_#{action}_before", :_cache_before
      alias_method "_cache_#{action}_after",  :_cache_after
    end

    def eager_cache(trigger_action, target = trigger_action, conditions = {}, &blk)
      target, conditions = trigger_action, target if target.is_a? Hash

      if target.is_a? Array
        target_controller, target_action = *target
      else
        target_controller, target_action = self, target
      end

      after("_eager_cache_#{trigger_action}_to_#{target_controller.name.snake_case}__#{target_action}_after", conditions.only(:if, :unless).merge(:with => [target_controller, target_action, conditions, blk], :only => trigger_action))
      alias_method "_eager_cache_#{trigger_action}_to_#{target_controller.name.snake_case}__#{target_action}_after", :_eager_cache_after
    end

    def eager_dispatch(action, env = {}, blk = nil)
      kontroller = new(Merb::Request.new(env))
      kontroller.force_cache!

      blk.call(kontroller) unless blk.nil?

      kontroller._dispatch(action)

      kontroller
    end
  end

  def fetch_partial(template, opts={}, conditions = {})
    template_id = template.to_s
    if template_id =~ %r{^/}
      template_path = File.dirname(template_id) / "_#{File.basename(template_id)}"
    else
      kontroller = (m = template_id.match(/.*(?=\/)/)) ? m[0] : controller_name
      template_id = "_#{File.basename(template_id)}"
    end

    unused, template_path = _template_for(template_id, opts.delete(:format) || content_type, kontroller, template_path)

    template_key = Merb::Template.template_name(template_path)

    Merb::Cache[_lookup_store(conditions)].fetch(template_key, opts, conditions) { partial(template, opts) }
  end

  def fetch_fragment(opts = {}, conditions = {}, &proc)
    file, line = proc.to_s.scan(%r{^#<Proc:0x\w+@(.+):(\d+)>$}).first

    fragment_key = "#{Merb::Template.template_name(file)}[#{line}]"

    Merb::Cache[_lookup_store(conditions)].fetch(fragment_key, opts, conditions) { yield }
  end

  def _cache_before(conditions = {})
    unless @_force_cache
      if @_skip_cache.nil? && data = Merb::Cache[_lookup_store(conditions)].read(self, _parameters_and_conditions(conditions).first)
        throw(:halt, data)
        @_cache_hit = true
      end
    end
  end

  def _cache_after(conditions = {})
    if @_skip_cache.nil? && Merb::Cache[_lookup_store(conditions)].write(self, nil, *_parameters_and_conditions(conditions))
      @_cache_write = true
    end
  end

  def _eager_cache_after(klass, action, conditions = {}, blk = nil)
    if @_skip_cache.nil?
      run_later do
        controller = klass.eager_dispatch(action, request.env, blk)

        Merb::Cache[controller._lookup_store(conditions)].write(controller, nil, *controller._parameters_and_conditions(conditions))
      end
    end
  end

  def eager_cache(action, conditions = {}, env = request.env.dup, &blk)
    unless @_skip_cache
      if action.is_a?(Array)
        klass, action = *action
      else
        klass = self.class
      end

      run_later do
        controller = klass.eager_dispatch(action, env, blk)
      end
    end
  end

  def _set_skip_cache
    @_skip_cache = true
  end

  def skip_cache!
    _set_skip_cache
  end

  def force_cache!
    @_force_cache = true
  end

  def _lookup_store(conditions = {})
    conditions[:store] || conditions[:stores] || default_cache_store
  end

  # Overwrite this in your controller to change the default store for a given controller
  def default_cache_store
    Merb::Cache.default_store_name
  end

  #ugly, please make me purdy'er
  def _parameters_and_conditions(conditions)
    parameters = {}

    if self.class.respond_to? :action_argument_list
      arguments, defaults = self.class.action_argument_list[action_name]
      arguments.inject(parameters) do |parameters, arg|
        if defaults.include?(arg.first)
          parameters[arg.first] = self.params[arg.first] || arg.last
        else
          parameters[arg.first] = self.params[arg.first]
        end
        parameters
      end
    end

    case conditions[:params]
    when Symbol
      parameters[conditions[:params]] = self.params[conditions[:params]]
    when Array
      conditions[:params].each do |param|
        parameters[param] = self.params[param]
      end
    end

    return parameters, conditions.except(:params, :store, :stores)
  end
end