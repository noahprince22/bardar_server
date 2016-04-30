module Heuristic

  # Calculate two tailed cdf with respect to time to calculate a weight.
  # @returns the time weighted average of all values in the list
  def self.normal(list, sd)
    total = 0.0
    n = 0.0
    list.each do |entry|
      weight = p_value(entry, sd)
      total += weight*entry[:value]
      n += weight
    end

    return total/n
  end

  private

  #   mean: now
  #   sd: the standard deviation. Effectively controls priority of new posts
  def self.p_value(entry, sd)
    time_from_mean_ms = entry[:time].strftime('%Q').to_i - DateTime.now.strftime('%Q').to_i
    z_0 = (time_from_mean_ms)/(sd * 60 * 1000) # sd minutes * 60 seconds/minute * 1000 ms/s
    return Distribution::Normal.cdf(z_0)*2 # The tail ends of the normal curve at this z score
  end
end