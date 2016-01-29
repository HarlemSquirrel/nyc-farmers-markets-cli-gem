class NYCFarmersMarkets::GetMarkets
  URL = "https://data.cityofnewyork.us/resource/cw3p-q2v6.json"

  def get_markets
    content = open(URL).read
    markets = JSON.parse(content)
  end

  def make_markets
    get_markets.each do |market_hash|
      NYCFarmersMarkets::Market.create_from_hash(market_hash)
    end
  end
end
