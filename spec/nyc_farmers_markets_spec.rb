require 'nyc_farmers_markets'
require "pry"

RSpec.describe NYCFarmersMarkets::GetMarkets, '#get_markets' do
  context "with internet connection" do
    it "retrieves and parses the JSON from NYC Open Data" do
      markets = NYCFarmersMarkets::GetMarkets.new.get_markets
      expect markets.length > 0
      expect markets[0]["facilitycity"].length > 0
      expect markets[0]["facilitystreetname"].length > 0
    end
  end
end

RSpec.describe NYCFarmersMarkets::GetMarkets, '#make_markets' do
  context "with internet connection" do
    it "creates instances of the Market class with data from NYC Open Data" do
      markets = NYCFarmersMarkets::GetMarkets.new.make_markets
      expect(markets.length > 0)
      expect(markets[0].name.length > 0)
      expect(markets[0].borough.length > 0)
    end
  end
end

RSpec.describe NYCFarmersMarkets::Market do
  it { should respond_to(:name) }
  it { should respond_to(:additional_info) }
  it { should respond_to(:street_address) }
  it { should respond_to(:borough) }
  it { should respond_to(:state) }
  it { should respond_to(:website) }
  it { should respond_to(:zipcode) }

  hash1 = {"facilityaddinfo"=>
    "Spend $5 in EBT and get a $2 Health Buck coupon.<br><br><b>Program Website:</b> <a  href=''http://www.grownyc.org/youthmarket'' target=''_blank''>http://www.grownyc.org/youthmarket</a>",
    "facilitycity"=>"Bronx",
    "facilityname"=>"Riverdale Youthmarket",
    "facilitystate"=>"NY",
    "facilitystreetname"=>"256th St & Mosholu Ave",
    "facilityzipcode"=>"10471",
    "latitude"=>"41",
    "longitude"=>"-74"}

  hash2 = {"facilityaddinfo"=>
    "Spend $5 in EBT and get a $2 Health Buck coupon.<br><br><b>Program Website:</b> <a  href=''http://www.grownyc.org.'' target=''_blank''>http://www.grownyc.org.</a>",
    "facilitycity"=>"Queens",
    "facilityname"=>"Astoria Greenmarket",
    "facilitystate"=>"NY",
    "facilitystreetname"=>"30th Dr",
    "facilityzipcode"=>"11106",
    "latitude"=>"41",
    "longitude"=>"-74"}

  describe '.create_from_hash' do
    it 'can create a new market with a hash' do
      market = NYCFarmersMarkets::Market.create_from_hash(hash1)
      expect market.name == hash1["facilityname"]
      expect market.additional_info == hash1["facilityaddinfo"]
      expect market.street_address == hash1["facilitystreetname"]
      expect market.borough == hash1["facilitycity"]
      expect market.state == hash1["facilitystate"]
      expect market.zipcode == hash1["facilityzipcode"]
    end
  end

  describe '#set_website_from_additional_info' do
    market = NYCFarmersMarkets::Market.new(additional_info: hash1["facilityaddinfo"])

    it 'can set the website from additonal info' do
      market.set_website_from_additional_info
      expect market.website == 'http://www.grownyc.org/youthmarket'
    end
  end

  describe '#remove_html' do
    market = NYCFarmersMarkets::Market.new(additional_info: hash1["facilityaddinfo"])

    it 'can remove HTML from additional info' do
      market.remove_html
      expect market.additional_info == 'Spend $5 in EBT and get a $2 Health Buck coupon.'
    end
  end

  market1 = NYCFarmersMarkets::Market.create_from_hash(hash1)
  market2 = NYCFarmersMarkets::Market.create_from_hash(hash2)
  market3 = NYCFarmersMarkets::Market.new(borough: hash1["facilitycity"], zipcode: hash1["facilityzipcode"])

  describe '.find_by_borough' do
    it 'can find all markets by borough' do
      borough = market1.borough
      markets = NYCFarmersMarkets::Market.all
      markets.select{ |m| m if m.borough != nil && m.borough.downcase == borough.downcase}

      expect NYCFarmersMarkets::Market.find_by_borough(borough) == markets
    end
  end

  describe '.find_by_zipcode' do
    it 'can find all markets by zipcode' do
      zipcode = market1.zipcode
      markets = NYCFarmersMarkets::Market.all
      markets.select{ |m| m if m.zipcode != nil && m.zipcode.downcase == zipcode.downcase}

      expect NYCFarmersMarkets::Market.find_by_zipcode(zipcode) == markets
    end
  end

  describe '.list_boroughs' do
    it 'can list all boroughs with markets' do
      expect NYCFarmersMarkets::Market.all.collect { |market| market.borough }.compact.uniq.sort ==  NYCFarmersMarkets::Market.list_boroughs
    end
  end

  describe '.list_zipcodes' do
    it 'can list all zipcodes with markets' do
      expect NYCFarmersMarkets::Market.all.collect { |market| market.zipcode }.compact.uniq.sort ==  NYCFarmersMarkets::Market.list_zipcodes
    end
  end

  describe '.num_markets_in_borough' do
    it 'knows the number of markets in a single borough' do
      expect NYCFarmersMarkets::Market.find_by_borough(market1.borough).count == NYCFarmersMarkets::Market.num_markets_in_borough(market1.borough)
    end
  end
end
