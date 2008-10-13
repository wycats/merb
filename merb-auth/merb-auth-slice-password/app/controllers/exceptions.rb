class Application < Merb::Controller; end

class Exceptions < Application
  include Merb::Slices::Support # Required to provide slice_url
  
  # # This stuff allows us to provide a default view
  the_view_path = File.expand_path(File.dirname(__FILE__) / ".." / "views")
  self._template_roots ||= []
  self._template_roots << [the_view_path, :_template_location]
  self._template_roots << [Merb.dir_for(:view), :_template_location]
    
  def unauthenticated
    provides :xml, :js, :json, :yaml
    
    session.abandon!

    case content_type
    when :html
      render
    else
      basic_authentication.request!
      ""
    end
  end
  
end