class BuilderController < Merb::Controller
  provides :xml
  self._template_root = File.dirname(__FILE__) / "views"
  def index
    render
  end
end

class PartialBuilder < BuilderController
end

class BuilderConfig < BuilderController
end

class PartialIvars < BuilderController
  def index
    @var1 = "Partial"
    render
  end
end

class CaptureBuilder < BuilderController
end

module Merb::ConcatBuilderHelper
  def concatter(&blk)
    concat("<node>Concat</node>", blk.binding)
  end
end

class ConcatBuilder < BuilderController
end