class Merb::AbstractController
  
  class << self
    alias_method :old_inherited, :inherited
    
    def inherited(klass)
      class << klass; attr_accessor :action_argument_list; end
      
      klass.action_argument_list = Hash.new do |h,k| 
        h[k] = ParseTreeArray.translate(klass, k.to_sym).get_args
      end      
      old_inherited(klass)
    end
  end
  
  def _call_action(action)
    args = self.class.action_argument_list[action].map do |arg, default|
      arg = arg
      raise BadRequest unless params.key?(arg.to_sym) || default
      params.key?(arg.to_sym) ? params[arg.to_sym] : default
    end
    send(action, *args)
  end
end