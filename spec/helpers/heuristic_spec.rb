require "spec_helper"
require "rails_helper"

describe("heuristics") do
  describe("#models_to_array") do
    it ("converts a list of models (e.g.) reports to an array as needed by normal") do
      attribute = :line_length
      report = Fabricate(:report, attribute => 5)
      Fabricate(:report, attribute => 5)

      arr = Heuristic.models_to_array(Report.where(id: report.id), attribute)

      expect(arr.first[:value]).to eq(5)
      expect(arr.first[:time].to_i).to eq(report.created_at.to_i) # to_i ignores millisecond difference
    end
  end

  describe("#normal_on_models_attribute") do
    it("returns an average of a value on all reports weighted with respect to time") do
      attribute = :cover_charge
      test_bar = Fabricate(:bar) # Using a new bar to identify all of these reports

      half_a_day = DateTime.now - 0.5
      five_minutes_ago = DateTime.now - 5.0/(60 * 12)
      now = DateTime.now
      Fabricate(:report, created_at: half_a_day, attribute => 0.5, bar: test_bar)
      Fabricate(:report, created_at: five_minutes_ago, attribute => 3,  bar: test_bar)
      Fabricate(:report, created_at: now, attribute => 1,  bar: test_bar)
      test_bar.reload

      weighted_avg = Heuristic.normal_on_models_attribute(test_bar.reports.recent, attribute, 30) # 15 minute std deviation
      expect(weighted_avg).to be_within(0.05).of(1.85) # Should be something like (0.73*3 + 1)/(0.87 + 1) = 1.85
    end
  end
end
