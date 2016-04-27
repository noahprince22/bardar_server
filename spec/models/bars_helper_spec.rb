require 'spec_helper'
require 'rails_helper'

RSpec.describe "YelpHelper" do
  let(:yelp) { spy(Yelp::Client) }

  describe "list for region" do
    let (:location) { 'San Francisco' }

    describe "non yelp dependent" do
      before(:each) do
        @search_result = double(Yelp::Response::Search)
        allow(@search_result).to receive(:businesses).and_return([id: "hello", name: "hello"])
        allow(yelp).to receive(:search)
                           .with(location, hash_including(category_filter: 'nightlife'))
                           .and_return(@search_result)

        @helper = YelpHelper.new(yelp)
      end
      it "gets list from yelp in chunks of 20" do
        allow(@search_result).to receive(:total).and_return(290)

        expect(yelp).to receive(:search).exactly(15).times

        bars = @helper.get_bars(location)

        expect(bars.first[:id]).to eq("hello")
        expect(bars.last[:name]).to eq("hello")
      end

      # per yelps requirements, you really can only get the top 1000 results. Any more and they cut you off
      # Do 1000, 1001, and 1500 to go from exact to close to not close
      it "gets only the top 1000 if there's 1000 results" do
        allow(@search_result).to receive(:total).and_return(1000)
        expect(yelp).to receive(:search).exactly(50).times

        @helper.get_bars(location)
      end

      it "gets only the top 1000 if there's 1001 results" do
        allow(@search_result).to receive(:total).and_return(1001)
        expect(yelp).to receive(:search).exactly(50).times

        @helper.get_bars(location)
      end

      it "gets only the top 1000 if there's 1500 results" do
        allow(@search_result).to receive(:total).and_return(1500)
        expect(yelp).to receive(:search).exactly(50).times

        @helper.get_bars(location)
      end
    end

    # For use in debugging actual results. Very slow so don't actually test on this
    describe("yelp dependent") do
      # it "receives a long list of results (limit 1000)" do
      #   YelpHelper.build_from_yelp_config.get_bars(location)
      # end
      it "receives a short list of results with real data" do
        YelpHelper.build_from_yelp_config.get_bars("Effingham")
      end
    end
  end
end