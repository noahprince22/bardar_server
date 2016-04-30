require "spec_helper"
require "rails_helper"

describe("heuristics") do
  describe("normal") do
    it ("takes a weighted average with respect to time") do
      list = [
        {
            value: 0,
            time: DateTime.now - 1
        },
        {
            value: 0.5,
            time: DateTime.now - 0.5
        },
        {
            value: 3,
            time: DateTime.now - 5.0/(60 * 12) # 5 minute proportion of the day
        },
        {
            value: 1,
            time: DateTime.now
        }
      ]

      # Should be something like (0.87*3 + 1)/(0.87 + 1)
      expect(Heuristic.normal(list, 5)).to be_within(0.1).of(1.93)
    end
  end
end
