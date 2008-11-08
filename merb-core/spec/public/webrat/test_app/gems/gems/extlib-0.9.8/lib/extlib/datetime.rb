class DateTime
  def to_time
    Time.parse self.to_s
  end
  
  def to_datetime
    self
  end
end