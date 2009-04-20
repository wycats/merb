# Declared to bypass a rubygems 1.3.2 bug :(
class Time
  def self.today
    t = Time.now
    t - ((t.to_f + t.gmt_offset) % 86400)
  end
end