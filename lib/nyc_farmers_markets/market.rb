class NYCFarmersMarkets::Market
  attr_accessor :name, :additional_info, :street_address, :borough, :state, :zipcode, :latitude, :longitude, :website

  @@all = []

  def initialize(name: nil, additional_info: nil, street_address: nil, borough: nil, state: "NY", zipcode: nil, website: nil)
    @name = name
    @additional_info = additional_info
    @street_address = street_address
    @borough = borough
    @state = state
    @zipcode = zipcode
  end

  def self.all
    @@all
  end

  def save
    @@all << self
  end

  def self.create_from_hash(h)
    market = self.new(
      name: h["facilityname"],
      additional_info: h["facilityaddinfo"],
      street_address: h["facilitystreetname"],
      borough: h["facilitycity"],
      state: h["facilitystate"],
      zipcode: h["facilityzipcode"]
    )

    market.set_website_from_additional_info

    market.save
  end

  def set_website_from_additional_info
    if @additional_info != nil
      url_from_info = @additional_info.match(/http:(\w|\/|\.|\&|\=|\?|\_)*</)
      @website = url_from_info[0].chomp("<").chomp(".") unless url_from_info == nil
    end
  end

  def self.find_by_borough(b)
    self.all.select do |market|
      market if market.borough == b
    end
  end

  def self.find_by_zipcode(z)
    self.all.select do |market|
      market if market.zipcode == z
    end
  end

  def self.list_boroughs
    self.all.collect { |market| market.borough }.compact.uniq.sort
  end

  def self.list_zipcodes
    self.all.collect { |market| market.zipcode }.compact.uniq.sort
  end
end
