class CacheController < Merb::Controller
  self._template_root = File.dirname(__FILE__) / "views"

  cache_action :action3
  cache_action :action4, 0.05

  cache_page :action5
  cache_page :action6, 0.05
  # or cache_pages :action5, [:action6, 0.05]
  cache_page :action7

  cache_action :action8, 0.05, :if => proc {|controller| !controller.params[:id].empty?}
  cache_action :action9, 0.05, :unless => proc {|controller| controller.params[:id].empty?}
  cache_action :action10, :if => :non_empty_id?
  cache_action :action11, :unless => :empty_id?

  cache_actions :cache_actions_1, [:cache_actions_2, 0.05], [:cache_actions_3, { :if => :empty_id? }]

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

  def action7
    provides :js, :css, :html, :xml, :jpg
    case params[:format]
    when "css"
      "CSS"
    when "js"
      "JS"
    when "html"
      "HTML"
    when "xml"
      "XML"
    when "jpg"
      "JPG"
    else
      raise "BAD FORMAT: #{params[:format].inspect}"
    end
  end

  def action8
    "test action8"
  end

  def action9
    "test action9"
  end

  def action10
    "test action10"
  end

  def action11
    "test action11"
  end

  def cache_actions_1
    'test cache_actions_1'
  end

  def cache_actions_2
    'test cache_actions_2'
  end

  def cache_actions_3
    'test cache_actions_3'
  end

  def index
    "test index"
  end

  private
    def empty_id?
      params[:id].empty?
    end

    def non_empty_id?
      !empty_id?
    end
end
