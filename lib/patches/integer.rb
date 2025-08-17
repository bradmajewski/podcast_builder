class Integer
  def to_clock
    hours = self / 3600
    minutes = (self % 3600) / 60
    seconds = self % 60
    if hours == 0
      if minutes == 0
        seconds.to_s
      else
        format("%d:%02d", minutes, seconds)
      end
    else
      format("%d:%02d:%02d", hours, minutes, seconds)
    end
  end
end
