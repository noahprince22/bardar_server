require 'spec_helper'
require 'rails_helper'

RSpec.describe BarsController do
  describe("GET near me") do
    it ("returns a list of closest bars sorted by distance") do
      bar = Fabricate(:bar)
      bar2 = Fabricate(:bar, latitude: bar.latitude + 0.0001, longitude: bar.longitude + 0.00001)
      bar3 = Fabricate(:bar, latitude: bar.latitude + 0.00001, longitude: bar.longitude + 0.00001)

      bars = [bar, bar3, bar2] # Enforce order

      post :near_me, latitude: bar.latitude, longitude: bar.longitude, radius: 20

      r = JSON.parse(response.body)

      # Only one returned
      expect(r.size).to eq(3)

      # Check that all attributes match
      bars.each_with_index do |b, index|
        expect(r[index]["id"]).to be_truthy

        r[index].each do |key, value|
          original_attr = b.attributes[key]
          if (value.is_a?(Integer))
            expect(value).to eq (original_attr)
          end

          if (value.is_a?(Float))
            expect(value).to be_within(0.005).of(original_attr) unless key == "distance"
          end
        end
      end
    end
  end
end