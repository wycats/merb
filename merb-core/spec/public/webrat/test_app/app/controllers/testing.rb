class Testing < Application

  # ...and remember, everything returned from an action
  # goes to the client...
  def index
    render
  end
  
  def next
    "<p>Got to next</p>"
  end
  
  def show_form
    render
  end
  
  def submit_form
    render(params.map do |param, value|
      "<p>#{param}: #{value}</p>"
    end.join("\n"))
  end
  
end
