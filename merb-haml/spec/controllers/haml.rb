class HamlController < Merb::Controller
  self._template_root = File.dirname(__FILE__) / "views"
  def index
    render
  end
end

class PartialHaml < HamlController
end

class HamlConfig < HamlController
end

class PartialIvars < HamlController
  def index
    @var1 = "Partial"
    render
  end
end

class CaptureHaml < HamlController
end

module Merb::ConcatHamlHelper
  def concatter(&blk)
    concat("<p>Concat</p>", blk.binding)
  end
end

class ConcatHaml < HamlController
end