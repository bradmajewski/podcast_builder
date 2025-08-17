class Integer
  def to_clock
    hours = self / 3600
    minutes = (self % 3600) / 60
    seconds = self % 60
    format("%02d:%02d:%02d", hours, minutes, seconds)
  end
end
