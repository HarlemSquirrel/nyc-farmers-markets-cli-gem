# frozen_string_literal: true

module NYCFarmersMarkets
  # Retrieves the from the NYC Open Data API
  class GetMarkets
    # https://data.cityofnewyork.us/dataset/DOHMH-Farmers-Markets-and-Food-Boxes/8vwk-6iz2
    API_URL = 'https://data.cityofnewyork.us/resource/94pk-v63f.json'

    def make_markets
      retrieved_markets.each do |market_hash|
        NYCFarmersMarkets::Market.create_from_hash(market_hash)
      end
      NYCFarmersMarkets::Market.all
    end

    private

    def retrieved_markets
      URI.parse(API_URL).open { |file| return JSON.parse(file.read) }
    end
  end
end
