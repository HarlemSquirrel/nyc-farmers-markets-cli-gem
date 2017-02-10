require 'spec_helper'

RSpec.describe NYCFarmersMarkets::GetMarkets do
  describe '#retrieve_markets' do
    let(:markets) { described_class.new.retrieve_markets }

    it "retrieves and parses the JSON from NYC Open Data" do
      expect(markets.length).to be > 0
      expect(markets[0]["facilitycity"].length).to be > 0
      expect(markets[0]["facilitystreetname"].length).to be > 0
    end

    describe '#make_markets' do
      let(:markets) { described_class.new.make_markets }

      it "creates instances of the Market class with data from NYC Open Data" do
        expect(markets.length).to be > 0
        expect(markets[0].name.length).to be > 0
        expect(markets[0].borough.length).to be > 0
      end
    end
  end
end
