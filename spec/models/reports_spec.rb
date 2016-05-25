require "spec_helper"
require "rails_helper"

RSpec.describe "Reports", type: :model  do
  let (:reports) { double(ActiveRecord::Associations::CollectionProxy) }
  before(:each) do
    @bar = Fabricate(:bar)
  end

  describe ("adding a new report") do
    # NOTE: The in-depth testing of current reports happens in bars_spec
    #   this just ensures that the report is properly telling the bar class to update it's current report
    it ("tells the bar to update it's current report") do
      allow(@bar).to receive(:report_added)

      # Insert 10 reports
      insert_reports(10, @bar)
      expect(@bar).to have_received(:report_added).exactly(10).times
    end

    it ("doesn't allow reports for the same bar to be added within 15 minutes of each other for the same user") do
      user = Fabricate(:user)
      Fabricate(:report, user: user, created_at: 14.minutes.ago)
      expect{ Fabricate(:report, user: user, created_at: Time.now) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end