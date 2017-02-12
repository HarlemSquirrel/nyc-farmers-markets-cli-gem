# frozen_string_literal: true

module NYCFarmersMarkets
  # Organizes the actual market data
  class Market
    attr_reader :additional_info, :additional_info_raw, :borough, :name, :state,
                :street_address, :latitude, :longitude, :website, :zip_code

    @all = []

    class << self
      attr_accessor :all
    end

    def initialize(attributes = {})
      @additional_info_raw = attributes[:additional_info_raw]
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
        additional_info_raw: h['facilityaddinfo'],
        street_address: h['facilitystreetname'],
        borough: h['facilitycity'],
        state: h['facilitystate'],
        zip_code: h['facilityzipcode']
      )
    end

    def cleanup
      set_website_from_additional_info_raw
      set_additional_info
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

    def self.boroughs
      @boroughs ||= all.collect(&:borough).compact.uniq.sort
    end

    def self.boroughs_lowercase
      @boroughs_lowercase ||= boroughs.map(&:downcase)
    end

    def self.zip_codes
      @zip_codes ||= all.collect(&:zip_code).compact.uniq.sort
    end

    def self.num_markets_in_borough(b)
      find_by_borough(b).count
    end

    def self.destroy_all!
      @all = []
    end

    private

    def set_website_from_additional_info_raw
      return if additional_info_raw.nil?
      url = additional_info_raw.match %r{http(:|\w|\/|\.|\&|\=|\?|\_)*<}
      return if url.nil?
      @website = url[0].chomp('<').chomp('.')
    end

    def set_additional_info
      return unless additional_info_raw
      @additional_info = additional_info_raw.match(/\A[^<]*/).to_s
      # return unless additional_info_raw && additional_info_raw.include?('<')
      # x = additional_info_raw.index('<') - 1
      # @additional_info = additional_info_raw.slice(0..x)
    end
  end
end
