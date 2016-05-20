class TimeNormalHeuristic
  #   mean: now
  #   sd: the standard deviation. Effectively controls priority of new posts
  def self.time_p_value(time, sd)
    time_from_mean_ms = time - Time.now
    z_0 = (time_from_mean_ms)/(sd * 60) # sd minutes * 60 seconds/minute
    return Distribution::Normal.cdf(z_0)*2 # The tail ends of the normal curve at this z score
  end
end