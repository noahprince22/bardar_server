require "spec_helper"
require "rails_helper"

RSpec.describe "Reports" do
  let (:reports) { double(ActiveRecord::Associations::CollectionProxy) }
  before(:each) do
    @bar = Fabricate(:bar)
  end

  describe ("adding a new report") do
    # NOTE: The in-depth testing of current reports happens in bars_spec
    #   this just ensures that the report is properly telling the bar class to update it's current report
    it ("tells the bar to update it's current report") do
      allow(@bar).to receive(:update_current_stats)

      # Insert 10 reports
      insert_reports(10, @bar)
      expect(@bar).to have_received(:update_current_stats).exactly(10).times
    end
  end
end