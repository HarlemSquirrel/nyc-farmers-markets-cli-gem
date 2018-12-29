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
      set_website_and_info_from_additional_info_raw
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

    def summary
      [name.green, full_address, additional_info, website, open_street_map_link]
        .compact.join("\n")
    end

    class << self
      attr_accessor :all

      def create(attributes)
        market = new attributes
        market.cleanup
        all << market
        market
      end

      def create_from_hash(hash)
        create(
          name: hash['facilityname'],
          additional_info_raw: hash['additionalinfo'],
          street_address: hash['address'],
          borough: hash['borough'],
          zip_code: hash['zipcode'],
          latitude: hash['latitude'],
          longitude: hash['longitude'],
          website: hash['website']
        )
      end

      def find_by_borough(query)
        all.select { |m| query.casecmp(m.borough.to_s).zero? }
      end

      def find_by_zip_code(query)
        all.select { |market| market.zip_code == query }
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

      def num_markets_in_borough(query)
        find_by_borough(query).count
      end

      def destroy_all!
        @all = []
      end
    end

    private

    def set_website_and_info_from_additional_info_raw
      return if additional_info_raw.to_s.empty?

      @additional_info ||= additional_info_raw.match(/\A[^<]*/).to_s
      url = additional_info_raw.match %r{http(:|\w|\/|\.|\&|\=|\?|\_)*<}
      return if url.nil?

      @website = url[0].chomp('<').chomp('.')
    end
  end
end
