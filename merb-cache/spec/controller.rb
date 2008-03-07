class CacheController < Merb::Controller
  self._template_root = File.dirname(__FILE__) / "views"

  cache_action :action3
  cache_action :action4, 0.05
  # or cache_actions :action3, [:action4, 0.05]

  cache_page :action5
  cache_page :action6, 0.05
  # or cache_pages :action5, [:action6, 0.05]

  def action1
    render
  end

  def action2
    render
  end

  def action3
    "test action3"
  end

  def action4
    "test action4"
  end

  def action5
    "test action5"
  end

  def action6
    Time.now.to_s
  end

  def index
    "test index"
  end
end
