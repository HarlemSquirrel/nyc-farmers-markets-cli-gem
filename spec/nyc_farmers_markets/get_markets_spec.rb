# frozen_string_literal: true

RSpec.describe NYCFarmersMarkets::GetMarkets do
  let(:data) { JSON.parse json }
  let(:get_markets) { described_class.new }
  let(:json) do
    '[
      {
        "facilityaddinfo":"Additional info 1",
        "facilitycity":"Bronx",
        "facilityname":"Riverdale Youthmarket",
        "facilitystate":"NY",
        "facilitystreetname":"256th St & Mosholu Ave",
        "facilityzipcode":"10471",
        "latitude":"41",
        "longitude":"-74"
      },
      {
        "facilityaddinfo":"Additional info 2",
        "facilitycity":"Queens",
        "facilityname":"Astoria Greenmarket",
        "facilitystate":"NY",
        "facilitystreetname":"30th Dr",
        "facilityzipcode":"11106",
        "latitude":"41",
        "longitude":"-74"
      }
    ]'
  end

  before do
    allow(File).to receive(:open) { json }
  end

  describe '#make_markets' do
    let(:markets) { NYCFarmersMarkets::Market.all }

    before do
      NYCFarmersMarkets::Market.destroy_all!
    end

    it 'creates instances of the Market class for each market retrieved' do
      expect { get_markets.make_markets }.to change { markets.count }.to data.length
    end

    it 'sets the market data' do
      get_markets.make_markets
      expect(markets.first.name).to eq data[0]['facilityname']
    end
  end
end
