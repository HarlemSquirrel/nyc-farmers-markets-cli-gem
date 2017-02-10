module NYCFarmersMarkets
  # Organizes the actual market data
  class Market
    attr_accessor(
      :name,
      :additional_info,
      :street_address,
      :borough,
      :state,
      :zipcode,
      :latitude,
      :longitude,
      :website
    )

    @@all = []

    def initialize(name: nil, additional_info: nil, street_address: nil, borough: nil, state: 'NY', zipcode: nil, website: nil)
      @name = name
      @additional_info = additional_info
      @street_address = street_address
      @borough = borough
      @state = state
      @zipcode = zipcode
      @website = website
    end

    def self.all
      @@all
    end

    def save
      @@all << self
    end

    def self.create_from_hash(h)
      market = new(
        name: h['facilityname'],
        additional_info: h['facilityaddinfo'],
        street_address: h['facilitystreetname'],
        borough: h['facilitycity'],
        state: h['facilitystate'],
        zipcode: h['facilityzipcode']
      )

      market.set_website_from_additional_info
      market.remove_html
      market.save
      market
    end

    def set_website_from_additional_info
      return if additional_info.nil?
      url_from_info = additional_info.match %r{http:(\w|\/|\.|\&|\=|\?|\_)*<}
      return if url_from_info.nil?
      self.website = url_from_info[0].chomp('<').chomp('.')
    end

    def remove_html
      return unless additional_info && additional_info.include?('<')
      x = additional_info.index('<')
      y = additional_info.length - 1
      additional_info.slice!(x..y)
    end

    def self.find_by_borough(b)
      all.select { |m| b.casecmp(m.borough.to_s).zero? }
    end

    def self.find_by_zipcode(z)
      all.select { |market| market.zipcode == z }
    end

    def self.list_boroughs
      all.collect(&:borough).compact.uniq.sort
    end

    def self.list_zipcodes
      all.collect(&:zipcode).compact.uniq.sort
    end

    def self.num_markets_in_borough(b)
      find_by_borough(b).count
    end
  end
end
