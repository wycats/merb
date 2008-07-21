<% with_modules(controller_modules) do -%>
class <%= controller_class_name %> < Application

  # ...and remember, everything returned from an action
  # goes to the client...
  def index
    render
  end
  
end
<% end -%>
