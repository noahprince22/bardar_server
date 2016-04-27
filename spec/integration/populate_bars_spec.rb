require "rails_helper"
require "spec_helper"

RSpec.describe "Application Populate All Bars" do
  it("can populate bars for a list of cities") do
    Bar.populate(["Effingham", "Champaign"])

    # Insert a debugger here and verify actual data
    expect(Bar.count).to be > 10
  end
end