class <%= module_name %>::Main < <%= module_name %>::Application
  
  def index
    render "#{<%= module_name %>.description} (v. #{<%= module_name %>.version})"
  end
  
end