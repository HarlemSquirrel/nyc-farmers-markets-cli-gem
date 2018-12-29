# frozen_string_literal: true

module NYCFarmersMarkets
  # Organizes the actual market data
  class Market
    attr_reader :additional_info, :additional_info_raw, :borough, :name, :state,
                :street_address, :latitude, :longitude, :website, :zip_code

    @all = []

    def initialize(attributes = {})
      attributes.each do |attribute, value|
        instance_variable_set "@#{attribute}", value
      end
      @state ||= 'NY'
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

    def open_street_map_link
      return if latitude.to_s.empty? || longitude.to_s.empty?
      'https://www.openstreetmap.org/' \
        "?mlat=#{latitude}&mlon=#{longitude}#map=11/#{latitude}/#{longitude}"
    end

    class << self
      attr_accessor :all


      def create(attributes)
        market = new attributes
        market.cleanup
        all << market
        market
      end

      def create_from_hash(h)
        create(
          name: h['facilityname'],
          additional_info_raw: h['additionalinfo'],
          street_address: h['address'],
          borough: h['borough'],
          zip_code: h['zipcode'],
          latitude: h['latitude'],
          longitude: h['longitude'],
          website: h['website']
        )
      end

      def find_by_borough(b)
        all.select { |m| b.casecmp(m.borough.to_s).zero? }
      end

      def find_by_zip_code(z)
        all.select { |market| market.zip_code == z }
      end

      def boroughs
        @boroughs ||= all.collect(&:borough).compact.uniq.sort
      end

      def boroughs_lowercase
        @boroughs_lowercase ||= boroughs.map(&:downcase)
      end

      def zip_codes
        @zip_codes ||= all.collect(&:zip_code).compact.uniq.sort
      end

      def num_markets_in_borough(b)
        find_by_borough(b).count
      end

      def destroy_all!
        @all = []
      end
    end

    private

    def set_website_from_additional_info_raw
      return if additional_info_raw.to_s.empty?
      url = additional_info_raw.match %r{http(:|\w|\/|\.|\&|\=|\?|\_)*<}
      return if url.nil?
      @website = url[0].chomp('<').chomp('.')
    end

    def set_additional_info
      return if additional_info_raw.to_s.empty?
      @additional_info ||= additional_info_raw.match(/\A[^<]*/).to_s
    end
  end
end
