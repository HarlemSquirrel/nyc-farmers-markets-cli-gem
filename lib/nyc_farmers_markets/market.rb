module NYCFarmersMarkets
  # Organizes the actual market data
  class Market
    attr_reader :additional_info, :borough, :name, :state, :street_address,
                :latitude, :longitude, :website, :zip_code

    @all = []

    class << self
      attr_accessor :all
    end

    def initialize(attributes={})
      @additional_info = attributes[:additional_info]
      @borough = attributes[:borough]
      @name = attributes[:name]
      @state = attributes[:state] ? attributes[:state] : 'NY'
      @street_address = attributes[:street_address]
      @latitude = attributes[:latitude]
      @longitude = attributes[:longitude]
      @website = attributes[:website]
      @zip_code = attributes[:zip_code]
    end

    def self.create(attributes)
      market = new attributes
      market.cleanup
      all << market
      market
    end

    def self.create_from_hash(h)
      create(
        name: h['facilityname'],
        additional_info: h['facilityaddinfo'],
        street_address: h['facilitystreetname'],
        borough: h['facilitycity'],
        state: h['facilitystate'],
        zip_code: h['facilityzipcode']
      )
    end

    def cleanup
      set_website_from_additional_info
      remove_html
      self
    end

    def full_address
      return '- address not available -' if street_address.nil?
      "#{street_address}, #{borough}, #{zip_code}"
    end

    def self.find_by_borough(b)
      all.select { |m| b.casecmp(m.borough.to_s).zero? }
    end

    def self.find_by_zip_code(z)
      all.select { |market| market.zip_code == z }
    end

    def self.list_boroughs
      all.collect(&:borough).compact.uniq.sort
    end

    def self.list_zip_codes
      all.collect(&:zip_code).compact.uniq.sort
    end

    def self.num_markets_in_borough(b)
      find_by_borough(b).count
    end

    private

    def set_website_from_additional_info
      return if additional_info.nil?
      url_from_info = additional_info.match %r{http:(\w|\/|\.|\&|\=|\?|\_)*<}
      return if url_from_info.nil?
      @website = url_from_info[0].chomp('<').chomp('.')
    end

    def remove_html
      return unless additional_info && additional_info.include?('<')
      x = additional_info.index('<')
      y = additional_info.length - 1
      additional_info.slice!(x..y)
    end
  end
end
