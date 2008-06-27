class Main < Merb::Controller
  self._template_root = File.dirname(__FILE__) / ".." / "views"
  
  def index
    part TodoPart => :list
  end
  
  def index2
    part TodoPart => :one    
  end
  
  def index3
    part(TodoPart => :one) + part(TodoPart => :list)
  end
  
  def index4
    provides :xml, :js
    part(TodoPart => :formatted_output)
  end
  
  def part_with_params
    part(TodoPart => :part_with_params, :my_param => "my_value")
  end
  
  def part_within_view
    render
  end
  
  def parth_with_absolute_template
    part(TodoPart => :parth_with_absolute_template)
  end
  
end