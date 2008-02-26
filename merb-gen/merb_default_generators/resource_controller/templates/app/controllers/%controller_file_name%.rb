<% counter = 0 -%>
<% controller_modules.each_with_index do |mod, i| -%>
<%= "  " * i %>module <%= mod %>
<% counter = i -%>
<% end -%>
<% counter = counter == 0 ? 0 : (counter + 1) -%>
<%= "  " * counter %>class <%= controller_class_name %> < Application
  
<%= "  " * counter %>  def index
<%= "  " * counter %>    render
<%= "  " * counter %>  end

<%= "  " * counter %>  def show
<%= "  " * counter %>    render
<%= "  " * counter %>  end

<%= "  " * counter %>  def new
<%= "  " * counter %>    render
<%= "  " * counter %>  end

<%= "  " * counter %>  def edit
<%= "  " * counter %>    render
<%= "  " * counter %>  end

<%= "  " * counter %>  def delete
<%= "  " * counter %>    render
<%= "  " * counter %>  end

<%= "  " * counter %>  def create
<%= "  " * counter %>    render
<%= "  " * counter %>  end

<%= "  " * counter %>  def update
<%= "  " * counter %>    render
<%= "  " * counter %>  end

<%= "  " * counter %>  def destroy
<%= "  " * counter %>    render
<%= "  " * counter %>  end
  
<%= "  " * counter %>end
<% counter = counter == 0 ? 0 : (counter - 1) -%>
<% controller_modules.reverse.each_with_index do |mod, i| -%>
<%= "  " * counter %>end # <%= mod %>
<% counter = counter - 1 -%>
<% end -%>