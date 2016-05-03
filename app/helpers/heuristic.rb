module Heuristic

  # Gets the weighted time average using the "normal" heuristic for every one of the models on the given attribute
  #   for example, running normal_on_models_attribute(Report.all, :line_length, 30) gives a 30 minute model avg out of
  #   all of the reports
  def self.normal_on_models_attribute(models, attribute, sd)
    return normal(models_to_array(models, attribute), sd)
  end

  def self.models_to_array(models, attribute)
    return models.map do |model|
      {
          value: model.instance_eval(attribute.to_s),
          time: model.created_at
      }
    end
  end

  # Calculate two tailed cdf with respect to time to calculate a weight.
  # @returns the time weighted average of all values in the list
  def self.normal(list, sd)
    total = 0.0
    n = 0.0
    list.each do |entry|
      weight = p_value(entry, sd) + 0.0000001 # Weight must always be nonzero
      total += weight*entry[:value]
      n += weight
    end

    return total/n
  end

  #   mean: now
  #   sd: the standard deviation. Effectively controls priority of new posts
  def self.p_value(entry, sd)
    time_from_mean_ms = entry[:time] - Time.now
    z_0 = (time_from_mean_ms)/(sd * 60) # sd minutes * 60 seconds/minute
    return Distribution::Normal.cdf(z_0)*2 # The tail ends of the normal curve at this z score
  end
end