# frozen_string_literal: true

module NYCFarmersMarkets
  # Retrieves the from the NYC Open Data API
  class GetMarkets
    URL = 'https://data.cityofnewyork.us/resource/cw3p-q2v6.json'

    def make_markets
      retrieve_markets.each do |market_hash|
        NYCFarmersMarkets::Market.create_from_hash(market_hash)
      end
      NYCFarmersMarkets::Market.all
    end

    private

    def retrieve_markets
      content = open(URL).read
      JSON.parse(content)
    end
  end
end
