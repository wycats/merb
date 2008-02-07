class Merb::AbstractController
  cattr_accessor :action_argument_list
  
  class << self
    alias_method :old_inherited, :inherited
    
    def inherited(klass)
      klass.action_argument_list = Hash.new do |h,k| 
        h[k] = ParseTreeArray.translate(klass, k.to_sym).get_args
      end
      old_inherited(klass)
    end
  end
  
  def _call_action(action)
    # [[:id], [:foo, 7]]
    args = self.class.action_argument_list[action].map do |arg_default|
      arg = arg_default[0]
      raise BadRequest unless params.key?(arg.to_sym) || (arg_default.size == 2)
      params.key?(arg.to_sym) ? params[arg.to_sym] : arg_default[1]
    end
    send(action, *args)
  end
end