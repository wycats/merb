module ExtraActions
  def self.included(base)
    base.show_action(:funky_inherited_method)
  end
  
  def funky_inherited_method(foo, bar)
    "#{foo} #{bar}"
  end
end


class ActionArgs < Merb::Controller
  include ExtraActions
  
  def index(foo)
    foo
  end
  
  def multi(foo, bar)
    "#{foo} #{bar}"
  end
  
  def defaults(foo, bar = "bar")
    "#{foo} #{bar}"
  end
  
  def defaults_mixed(foo, bar ="bar", baz = "baz")
    "#{foo} #{bar} #{baz}"
  end
  
  define_method :dynamic_define_method do
    "mos def"
  end
  
end