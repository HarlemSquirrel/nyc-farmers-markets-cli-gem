class NYCFarmersMarkets::GetMarkets
  URL = "https://data.cityofnewyork.us/resource/cw3p-q2v6.json"

  def get_markets
    uri = URI.parse(URL)
    response = Net::HTTP.get_response(uri)
    markets = JSON.parse(response.body)
  end

  def make_markets
    #binding.pry
    get_markets.each do |market_hash|
      NYCFarmersMarkets::Market.create_from_hash(market_hash)
      #Market.create_from_hash(market_hash)
    end
  end
end
