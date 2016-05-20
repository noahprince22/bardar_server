module Aggregate
  def value(model, attribute, args)
    return model.instance_eval(attribute.to_s)
  end

  # Calculate the weighted average of a list using weight and value function
  def self.weighted_average(list, value_fn, weight_fn)
    total = 0.0
    n = 0.0
    list.each do |entry|
      w = weight_fn.call(entry)
      total += w * value_fn.call(entry)
      n += w
    end

    return total/n
  end
end