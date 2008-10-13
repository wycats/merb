<% with_modules(modules) do -%>
class <%= class_name %> < Application

  # ...and remember, everything returned from an action
  # goes to the client...
  def index
    render
  end
  
end
<% end -%>
