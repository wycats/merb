class HamlController < Merb::Controller
  self._template_root = File.dirname(__FILE__) / "views"
  def index
    render
  end
end

class PartialHaml < HamlController
  def index
    render
  end
end

class HamlConfig < HamlController
  def index
    render
  end
end

class PartialIvars < HamlController
  def index
    @var1 = "Partial"
    render
  end
end
