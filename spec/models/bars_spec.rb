require "spec_helper"
require "rails_helper"

RSpec.describe "Bars" do
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

      Bar.populate(["Chicago", "Champaign"],yelper)

      count = 0
      Bar.find_each do |bar|
        expect(bar.yelp_id).to eq(id)
        expect(bar.name).to eq(name)
        expect(bar.lat).to eq(lat)
        expect(bar.lng).to eq(lng)
        count+=1
      end

      expect(count).to eq(2)
    end
  end
end