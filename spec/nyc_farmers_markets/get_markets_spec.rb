# frozen_string_literal: true

RSpec.describe NYCFarmersMarkets::GetMarkets do
  let(:data) { JSON.parse json }
  let(:get_markets) { described_class.new }
  let(:json) { File.read json_file_path }
  let(:json_file_path) { 'spec/support/network_stubs/responses/markets_2.json' }

  before do
    stub_const "#{described_class}::URL", json_file_path
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
