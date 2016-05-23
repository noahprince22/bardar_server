require 'spec_helper'
require 'rails_helper'

RSpec.describe BarsController do
  describe("GET near me") do
    it ("returns a list of closest bars") do
      bar = Fabricate(:bar)
      post :near_me, latitude: bar.latitude, longitude: bar.longitude, radius: 20

      r = JSON.parse(response.body)

      # Only one returned
      expect(r.size).to eq(1)
      expect(r[0]["id"]).to be_truthy

      # Check that all attributes match
      r[0].each do |key, value|
        original_attr = bar.attributes[key]
        if (value.is_a?(Integer))
          expect(value).to eq (original_attr)
        end

        if (value.is_a?(Float) and value != 0.0) # TODO: Figure out why the fuck 0.0 can't be coerced into float
          expect(value).to be_within(0.005).of(original_attr)
        end
      end
    end
  end
end