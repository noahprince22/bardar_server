require "spec_helper"
require "rails_helper"

RSpec.describe "Bars" do
  describe ("current reports") do
    it("creates a default current report") do
      expect(Fabricate(:bar).reports.current).to be_a(Report)
    end

    it ("#get_current_report") do
      #@bar = create(:bar)
      #@user = create(:user)
      @report = Fabricate(:report, is_current: true)

      expect(@report.bar.reports.current.id).to be(@report.id)
    end

    describe("#update_current_stats") do
      before(:each) do
        @bar = Fabricate(:bar)
      end

      it("has a lower average when a 0 report is added") do
        insert_reports(10, @bar) #first get a running average

        old = @bar.reports.current

        # This *should* lower the average for everything under
        #  any reasonable heuristic
        Fabricate(:report,
                  line_length: 0,
                  cover_charge: 0,
                  ratio: 0,
                  avg_age: 0,
                  bar: @bar,
                  crowd: 0,
                  created_at: DateTime.now)

        current = @bar.reports.current

        expect(old.line_length).to be > current.line_length
        expect(old.cover_charge).to be > current.cover_charge
        expect(old.ratio).to be > current.ratio
        expect(old.avg_age).to be > current.avg_age
        expect(old.crowd).to be > current.crowd
        expect(Bar.find(@bar.id).freshness).to be > @bar.freshness
      end
    end
  end

  describe ("populating") do
    let (:yelper) { double(YelpHelper) }
    let (:business) { double(Yelp::Response::Model::Business) }
    let (:location) { double(Yelp::Response::Model::Location) }
    let (:coordinate) { double(Yelp::Response::Model::Coordinate) }

    let (:id) { "id" }
    let (:name) { "name" }
    let (:lat) { 26 }
    let (:lng) { 27 }

    it ("can populate the database given a list of cities that are supported") do
      allow(business).to receive(:id).and_return id
      allow(business).to receive(:name).and_return name
      allow(business).to receive(:location).and_return location

      allow(location).to receive(:coordinate).and_return coordinate

      allow(coordinate).to receive(:latitude).and_return lat
      allow(coordinate).to receive(:longitude).and_return lng

      allow(yelper).to receive(:get_bars).and_return([business])

      Bar.populate(["Chicago", "Champaign"], yelper)

      count = 0
      Bar.find_each do |bar|
        expect(bar.yelp_id).to eq(id)
        expect(bar.name).to eq(name)
        expect(bar.latitude).to eq(lat)
        expect(bar.longitude).to eq(lng)
        count+=1
      end

      expect(count).to eq(1) # Should not include duplicates
    end
  end
end