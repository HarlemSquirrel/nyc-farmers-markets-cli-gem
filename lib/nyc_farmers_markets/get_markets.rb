# frozen_string_literal: true

module NYCFarmersMarkets
  # Retrieves the from the NYC Open Data API
  class GetMarkets
    # https://data.cityofnewyork.us/dataset/DOHMH-Farmers-Markets-and-Food-Boxes/8vwk-6iz2
    URL = 'https://data.cityofnewyork.us/resource/94pk-v63f.json'

    def make_markets
      retrieved_markets.each do |market_hash|
        NYCFarmersMarkets::Market.create_from_hash(market_hash)
      end
      NYCFarmersMarkets::Market.all
    end

    private

    def retrieved_markets
      JSON.parse open(URL).read
    end
  end
end
