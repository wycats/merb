# FIXME: PK: Delete this when removing the json pure fix
require File.join(File.dirname(__FILE__), "spec_helper")

require "benchmark"

begin
  gem "json_pure", "<= 1.1.6"
rescue LoadError
  Merb.fatal! "This test is testing a vulnerability that was present in JSON::Pure 1.1.6 but not in later " \
              "versions. In order to run this test, you must have json_pure 1.1.6 or lower on your system."
end

class Merb::BootLoader::Dependencies
  extend(Module.new do
    def require(name)
      raise LoadError if name == "json/ext"
      super
    end
  end)
end

startup_merb

describe "JSON pure vulnerability" do
  it "can finish parsing a JSON document that could be exploited" do
    ["\\/", "\\\\", "\\\"", "\\b", "\\n", "\\f", "\\r", "\\t"].each do |char|
      bad_json = "{\"a\":\"" + (char * 20) + "\000\"}"

      success = false

      time = Benchmark.measure { JSON.parse(bad_json) rescue nil }.real
      time.should_not > 0.1
    end
  end
end
