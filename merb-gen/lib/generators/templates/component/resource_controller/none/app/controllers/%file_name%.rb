<% with_modules(modules) do -%>
class <%= class_name %> < Application
  
  # GET /<%= symbol_name %>
  def index
    render
  end

  # GET /<%= symbol_name %>/:id
  def show
    render
  end

  # GET /<%= symbol_name %>/new
  def new
    render
  end

  # GET /<%= symbol_name %>/:id/edit
  def edit
    render
  end

  # GET /<%= symbol_name %>/:id/delete
  def delete
    render
  end

  # POST /<%= symbol_name %>
  def create
    render
  end

  # PUT /<%= symbol_name %>/:id
  def update
    render
  end

  # DELETE /<%= symbol_name %>/:id
  def destroy
    render
  end
end
<% end -%>